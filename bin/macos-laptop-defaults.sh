#!/usr/bin/env bash
#
# Apple macOS defaults
# This script configures macOS system preferences via the defaults command
#
# @author Glenn Brown
#
# @see: https://macos-defaults.com
# @see: https://herrbischoff.com/code/me/awesome-macos-command-line

set -e  # Exit on error

echo "Configuring macOS defaults..."

# Close System Preferences to prevent overriding settings
osascript -e 'tell application "System Settings" to quit'

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Setting general UI/UX preferences..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable smart quotes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true

# Disable smart dashes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true

# Automatically quit printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Trackpad, Mouse, Keyboard, Bluetooth Accessories, and Input                #
###############################################################################

echo "Configuring input devices..."

# Trackpad: Haptic feedback (light, silent clicking)
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0

# Trackpad: Map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write NSGlobalDomain ContextMenuGesture -int 1

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Screenshots                                                                 #
###############################################################################

echo "Configuring screenshot settings..."

# Save screenshots to Documents/Screenshots folder
mkdir -p ~/Documents/Screenshots
defaults write com.apple.screencapture location -string "~/Documents/Screenshots"

# Save screenshots as JPG
defaults write com.apple.screencapture type -string "jpg"

# Disable shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

echo "Configuring Finder..."

# Show icons for hard drives, servers, and removable media on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Automatically empty Recycle Bin after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true

# Clicking wallpaper on only shows desktop when in Stage Manager
defaults write com.apple.WindowManager -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0.1

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes: icnv (icon), Nlsv (list), clmv (column), Flwv (gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Dock, Dashboard, and Hot Corners                                           #
###############################################################################

echo "Configuring Dock..."

# Set icon size of Dock items
defaults write com.apple.dock tilesize -int 36

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Autohide Dock
defaults write com.apple.dock autohide -bool true

# Speed up hide/show Dock animations
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Use scale effect with Dock
defaults write com.apple.dock mineffect -string "scale"

# Left align Dock
defaults write com.apple.dock orientation -string "right"

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't show recent apps
defaults write com.apple.dock show-recents -bool false

# Expose/Mission Control: Group apps
defaults write com.apple.dock expose-group-apps -bool true

# Hot corners
# Bottom right: Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

# Top right: Put display to sleep (with Command key)
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 1048576

# Bottom left: Desktop (with Command key)
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 1048576

# Top left: Start screen saver (with Command key)
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 1048576

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

echo "Configuring Safari..."

# Enable Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Add context menu item for showing Web Inspector
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show full URL in address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

echo "Configuring Mail..."

# Copy email addresses as foo@example.com instead of Foo Bar <foo@example.com>
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "Configuring Activity Monitor..."

# Show main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

###############################################################################
# App Store                                                                   #
###############################################################################

echo "Configuring App Store..."

# Disable in-app rating requests
defaults write com.apple.AppStore InAppReviewEnabled -int 0

###############################################################################
# Time Machine                                                                #
###############################################################################

echo "Configuring Time Machine..."

# Don't offer new disks for Time Machine backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Finder Preferences                                                          #
###############################################################################

echo "Configuring Finder Preferences..."

# Sort Desktop icons by kind
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

# Default to grid for other icon views
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Enable item info on the desktop and labels to the right of icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Set the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 72" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

###############################################################################
# Messages                                                                    #
###############################################################################

echo "Configuring Messages..."

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "Restarting affected applications..."

for app in "Activity Monitor" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Safari" \
    "SystemUIServer"; do
    killall "${app}" &> /dev/null || true
done

echo "Done! Some changes may require a logout/restart to take effect."