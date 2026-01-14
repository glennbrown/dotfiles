#!/usr/bin/env bash

#
# Apple macOS defaults
# This script configures macOS system preferences via the defaults command
#
# @author Glenn Brown
#
# @see: https://macos-defaults.com
# @see: https://herrbischoff.com/code/me/awesome-macos-command-line

set -e

echo "Setting macOS defaults..."

# General UI/UX
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate, and make it happen more quickly.
# (The KeyRepeat option requires logging out and back in to take effect.)
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Screenshots
# Save screenshots to Documents/Screenshots folder
defaults write com.apple.screencapture location -string "~/Documents/Screenshots"

# Save as jpg
defaults write com.apple.screencapture type -string "jpg"

# Disable shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Finder
# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: Keep Folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Automatically Empty Recycle bin after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true

# Clicking wallpaper on only shows desktop when in Stage Manager
defaults write com.apple.WindowManager -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0.1

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Dock, Dashboard and hot corners
# Set the icon size of Dock items
defaults write com.apple.dock tilesize -float 42

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Speed up hide/show dock animations
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Use scale effect with dock
defaults write com.apple.dock mineffect -string "scale"

# Don't show recent apps
defaults write com.apple.dock show-recents -bool false

# Expose/Mission Control Group Apps
defaults write com.apple.dock expose-group-apps -bool true

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Safari & Webkit
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.safari IncludeDevelopMenu -bool true
defaults write com.apple.safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show Full URL in Address Bar
defaults write com.apple.safari ShowFullURLInSmartSearchField -bool true

# Activity Monitor
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# App Store
# Disable in-app rating requests from apps downloaded from the App Store.
defaults write com.apple.appstore InAppReviewEnabled -int 0

# Time Machine
# Don't offer new disks for Time Machine backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Done! Restarting affected services..."

# Restart services to apply changes
killall Dock
killall Finder
killall SystemUIServer
killall WindowManager

echo "macOS defaults have been set successfully!"
echo "Note: Some changes may require logging out and back in to take full effect."