#!/usr/bin/env bash

set -e

# Default configuration file path
CONFIG_FILE="$HOME/.dock-config.yaml"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--conf)
            CONFIG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-c|--conf config-file.yaml]"
            echo ""
            echo "Options:"
            echo "  -c, --conf    Path to configuration file (default: ~/.dock-config.yaml)"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found"
    exit 1
fi

# Check if yq is installed
echo "Checking for yq..."
if ! command -v yq &> /dev/null; then
    echo "Installing yq via Homebrew..."
    brew install yq
else
    echo "yq is already installed"
fi

# Install dockutil if not already installed
echo "Checking for dockutil..."
if ! command -v dockutil &> /dev/null; then
    echo "Installing dockutil via Homebrew..."
    brew install dockutil
else
    echo "dockutil is already installed"
fi

# Parse YAML config file
ITEMS_TO_REMOVE=$(yq eval '.dockitems_remove[]?' "$CONFIG_FILE" 2>/dev/null || echo "")
ITEMS_TO_ADD=$(yq eval -o=json '.dockitems_persist[]?' "$CONFIG_FILE" 2>/dev/null || echo "")

# Remove configured Dock items
echo ""
echo "Removing Dock items..."
if [[ -n "$ITEMS_TO_REMOVE" ]]; then
    REMOVE_COUNT=$(echo "$ITEMS_TO_REMOVE" | wc -l | tr -d ' ')
    CURRENT=0
    
    while IFS= read -r item; do
        CURRENT=$((CURRENT + 1))
        echo "Checking if '$item' is in the Dock..."
        
        if dockutil --find "$item" &> /dev/null; then
            echo "Removing '$item' from Dock..."
            if [[ $CURRENT -eq $REMOVE_COUNT ]]; then
                dockutil --remove "$item"
            else
                dockutil --remove "$item" --no-restart
            fi
        else
            echo "'$item' not found in Dock, skipping..."
        fi
    done <<< "$ITEMS_TO_REMOVE"
    
    if [[ $CURRENT -gt 0 ]]; then
        echo "Pausing for 7 seconds..."
        sleep 7
    fi
else
    echo "No items to remove"
fi

# Add configured Dock items
echo ""
echo "Adding Dock items..."
if [[ -n "$ITEMS_TO_ADD" ]]; then
    ADD_COUNT=$(echo "$ITEMS_TO_ADD" | wc -l | tr -d ' ')
    CURRENT=0
    ADDED=false
    
    while IFS= read -r item_json; do
        CURRENT=$((CURRENT + 1))
        NAME=$(echo "$item_json" | yq eval '.name' -)
        PATH=$(echo "$item_json" | yq eval '.path' -)
        
        echo "Checking if '$NAME' exists in Dock..."
        
        if dockutil --find "$NAME" &> /dev/null; then
            SECTION=$(dockutil --find "$NAME" | sed -n 's/.*was found in \(.*\) at slot.*/\1/p')
            
            if [[ "$SECTION" == "recent-apps" ]]; then
                echo "'$NAME' found in recent-apps section, re-adding..."
                if [[ $CURRENT -eq $ADD_COUNT ]]; then
                    dockutil --add "$PATH" --label "$NAME"
                else
                    dockutil --add "$PATH" --label "$NAME" --no-restart
                fi
                ADDED=true
            else
                echo "'$NAME' already exists in Dock, skipping..."
            fi
        else
            echo "Adding '$NAME' to Dock..."
            if [[ $CURRENT -eq $ADD_COUNT ]]; then
                dockutil --add "$PATH" --label "$NAME"
            else
                dockutil --add "$PATH" --label "$NAME" --no-restart
            fi
            ADDED=true
        fi
    done <<< "$ITEMS_TO_ADD"
    
    if [[ $ADDED == true ]]; then
        echo "Pausing for 7 seconds..."
        sleep 7
    fi
else
    echo "No items to add"
fi

# Position configured Dock items
echo ""
echo "Positioning Dock items..."
if [[ -n "$ITEMS_TO_ADD" ]]; then
    # Count items that have a position defined
    POSITION_COUNT=0
    while IFS= read -r item_json; do
        POS=$(echo "$item_json" | yq eval '.pos // "null"' -)
        if [[ "$POS" != "null" ]] && [[ "$POS" -gt 0 ]] 2>/dev/null; then
            POSITION_COUNT=$((POSITION_COUNT + 1))
        fi
    done <<< "$ITEMS_TO_ADD"
    
    CURRENT=0
    
    while IFS= read -r item_json; do
        NAME=$(echo "$item_json" | yq eval '.name' -)
        POS=$(echo "$item_json" | yq eval '.pos // "null"' -)
        
        if [[ "$POS" == "null" ]] || [[ "$POS" -le 0 ]] 2>/dev/null; then
            continue
        fi
        
        CURRENT=$((CURRENT + 1))
        
        echo "Checking position of '$NAME'..."
        if DOCK_OUTPUT=$(dockutil --find "$NAME" 2>&1); then
            CURRENT_POS=$(echo "$DOCK_OUTPUT" | sed -n 's/.*slot \([0-9]*\) in.*/\1/p')
            
            if [[ "$CURRENT_POS" -ne "$POS" ]]; then
                echo "Moving '$NAME' to position $POS (currently at $CURRENT_POS)..."
                if [[ $CURRENT -eq $POSITION_COUNT ]]; then
                    dockutil --move "$NAME" --position "$POS"
                else
                    dockutil --move "$NAME" --position "$POS" --no-restart
                fi
            else
                echo "'$NAME' is already at position $POS"
            fi
        else
            echo "Warning: Could not find '$NAME' in Dock"
        fi
    done <<< "$ITEMS_TO_ADD"
else
    echo "No items to position"
fi

echo ""
echo "Dock management complete!"