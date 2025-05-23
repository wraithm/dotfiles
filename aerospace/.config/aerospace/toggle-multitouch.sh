#!/usr/bin/env bash

# Check current state
current=$(defaults read com.apple.AppleMultitouchTrackpad Clicking)

if [ "$current" = "0" ]; then
    echo "Enabling native macOS tap to click and secondary click..."

    # Enable native trackpad settings
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1

    # Apply settings
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # Kill Multitouch.app if it's running
    if pgrep -x "Multitouch" > /dev/null; then
        echo "Stopping Multitouch.app..."
        killall "Multitouch" 2>/dev/null || true
    fi

    echo "✓ Native trackpad gestures enabled, Multitouch.app stopped"
else
    echo "Disabling native gestures for Multitouch.app..."

    # Disable native trackpad settings
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 0

    # Apply settings
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # Launch Multitouch.app using explicit path
    echo "Starting Multitouch.app..."
    open "/Applications/Multitouch.app"

    echo "✓ Native gestures disabled, Multitouch.app started"
fi
