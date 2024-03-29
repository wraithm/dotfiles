// -*- mode: gnome-shell -*-

var Meta = imports.gi.Meta;
var Clutter = imports.gi.Clutter;
var St = imports.gi.St;
var Main = imports.ui.main;
var Shell = imports.gi.Shell;

// Extension local imports
var Extension, Me, Tiling, Utils, App, Keybindings, Examples;

// function launchEmacsFrame() {
//     imports.misc.util.spawn(['emacsclient', '--eval', '(make-frame)']);
// }

function init() {
    // Runs _only_ once on startup

    // Initialize extension imports here to make gnome-shell-reload work
    // Extension = imports.misc.extensionUtils.getCurrentExtension();
    // Me = Extension.imports.user;
    // Tiling = Extension.imports.tiling;
    // Utils = Extension.imports.utils;
    // Keybindings = Extension.imports.keybindings;
    // Examples = Extension.imports.examples;
    // App = Extension.imports.app;

    // Multi-monitor controls
    // Examples.keybindings.moveSpaceToMonitor();
    // Examples.keybindings.cycleMonitor();

    // bind C-M-e to open in emacs
    // Keybindings.bindkey(
    //     "<ctrl><alt>e", "open-emacs",
    //     launchEmacsFrame,
    //     { activeInNavigator: false }
    // );

    // s-n in emacs opens a new emacs frame
    // App.customHandlers['emacs_emacs.desktop'] = launchEmacsFrame;

    // Slack is a scratch window
    // Tiling.defwinprop({
    //     wm_class: "Slack",
    //     scratch_layer: true,
    // });

}

function enable() {
    // Runs on extension reloads, eg. when unlocking the session
}

function disable() {
    // Runs on extension reloads eg. when locking the session (`<super>L).
}
