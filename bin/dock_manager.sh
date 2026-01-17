#!/usr/bin/env bash

set -e

# Ensure system binaries are in PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Ensure Homebrew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

# Define tool paths
DOCKUTIL_BIN="${HOMEBREW_PREFIX}/bin/dockutil"
YQ_BIN="${HOMEBREW_PREFIX}/bin/yq"

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
if ! command -v "$YQ_BIN" &> /dev/null; then
    echo "Installing yq via Homebrew..."
    brew install yq
else
    echo "yq is already installed"
fi

# Install dockutil if not already installed
echo "Checking for dockutil..."
if ! command -v "$DOCKUTIL_BIN" &> /dev/null; then
    echo "Installing dockutil via Homebrew..."
    brew install dockutil
else
    echo "dockutil is already installed"
fi

# Parse YAML config file
ITEMS_TO_REMOVE=$("$YQ_BIN" eval '.dockitems_remove[]?' "$CONFIG_FILE" 2>/dev/null || echo "")

# Remove configured Dock items
echo ""
echo "Removing Dock items..."
if [[ -n "$ITEMS_TO_REMOVE" ]]; then
    REMOVE_COUNT=$(echo "$ITEMS_TO_REMOVE" | wc -l | tr -d ' ')
    CURRENT=0
    
    while IFS= read -r item; do
        CURRENT=$((CURRENT + 1))
        echo "Checking if '$item' is in the Dock..."
        
        if "$DOCKUTIL_BIN" --find "$item" &> /dev/null; then
            echo "Removing '$item' from Dock..."
            if [[ $CURRENT -eq $REMOVE_COUNT ]]; then
                "$DOCKUTIL_BIN" --remove "$item"
            else
                "$DOCKUTIL_BIN" --remove "$item" --no-restart
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
ADD_COUNT=$("$YQ_BIN" eval '.dockitems_persist | length' "$CONFIG_FILE" 2>/dev/null || echo "0")

if [[ "$ADD_COUNT" -gt 0 ]]; then
    CURRENT=0
    ADDED=false
    
    for ((i=0; i<ADD_COUNT; i++)); do
        CURRENT=$((CURRENT + 1))
        NAME=$("$YQ_BIN" eval ".dockitems_persist[$i].name" "$CONFIG_FILE")
        APP_PATH=$("$YQ_BIN" eval ".dockitems_persist[$i].path" "$CONFIG_FILE")
        
        echo "Checking if '$NAME' exists in Dock..."
        
        if "$DOCKUTIL_BIN" --find "$NAME" &> /dev/null; then
            echo "DEBUG: PATH=$PATH"
            SECTION=$("$DOCKUTIL_BIN" --find "$NAME" | sed -n 's/.*was found in \(.*\) at slot.*/\1/p')
            
            if [[ "$SECTION" == "recent-apps" ]]; then
                echo "'$NAME' found in recent-apps section, re-adding..."
                if [[ $CURRENT -eq $ADD_COUNT ]]; then
                    "$DOCKUTIL_BIN" --add "$APP_PATH" --label "$NAME"
                else
                    "$DOCKUTIL_BIN" --add "$APP_PATH" --label "$NAME" --no-restart
                fi
                ADDED=true
            else
                echo "'$NAME' already exists in Dock, skipping..."
            fi
        else
            echo "Adding '$NAME' to Dock..."
            if [[ $CURRENT -eq $ADD_COUNT ]]; then
                "$DOCKUTIL_BIN" --add "$APP_PATH" --label "$NAME"
            else
                "$DOCKUTIL_BIN" --add "$APP_PATH" --label "$NAME" --no-restart
            fi
            ADDED=true
        fi
    done
    
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
PERSIST_COUNT=$("$YQ_BIN" eval '.dockitems_persist | length' "$CONFIG_FILE" 2>/dev/null || echo "0")

if [[ "$PERSIST_COUNT" -gt 0 ]]; then
    # Count items that have a position defined
    POSITION_COUNT=0
    for ((i=0; i<PERSIST_COUNT; i++)); do
        POS=$("$YQ_BIN" eval ".dockitems_persist[$i].pos // null" "$CONFIG_FILE")
        if [[ "$POS" != "null" ]] && [[ "$POS" -gt 0 ]] 2>/dev/null; then
            POSITION_COUNT=$((POSITION_COUNT + 1))
        fi
    done
    
    CURRENT=0
    
    for ((i=0; i<PERSIST_COUNT; i++)); do
        NAME=$("$YQ_BIN" eval ".dockitems_persist[$i].name" "$CONFIG_FILE")
        POS=$("$YQ_BIN" eval ".dockitems_persist[$i].pos // null" "$CONFIG_FILE")
        
        if [[ "$POS" == "null" ]] || [[ "$POS" -le 0 ]] 2>/dev/null; then
            continue
        fi
        
        CURRENT=$((CURRENT + 1))
        
        echo "Checking position of '$NAME'..."
        if DOCK_OUTPUT=$("$DOCKUTIL_BIN" --find "$NAME" 2>&1); then
            CURRENT_POS=$(echo "$DOCK_OUTPUT" | sed -n 's/.*slot \([0-9]*\) in.*/\1/p')
            
            if [[ "$CURRENT_POS" -ne "$POS" ]]; then
                echo "Moving '$NAME' to position $POS (currently at $CURRENT_POS)..."
                if [[ $CURRENT -eq $POSITION_COUNT ]]; then
                    "$DOCKUTIL_BIN" --move "$NAME" --position "$POS"
                else
                    "$DOCKUTIL_BIN" --move "$NAME" --position "$POS" --no-restart
                fi
            else
                echo "'$NAME' is already at position $POS"
            fi
        else
            echo "Warning: Could not find '$NAME' in Dock"
        fi
    done
else
    echo "No items to position"
fi

echo ""
echo "Dock management complete!"