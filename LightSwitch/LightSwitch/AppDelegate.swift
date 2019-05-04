//
//  AppDelegate.swift
//  LightSwitch
//
//  Created by Oscar Nord on 2019-05-04.
//  Copyright © 2019 Oscar Nord. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //status bar item object
    var statusItem: NSStatusItem?
    @IBOutlet weak var appMenu: NSMenu!
    
    @objc func displayMenu() {
        guard let button = statusItem?.button else { return }
        let x = button.frame.origin.x
        let y = button.frame.origin.y - 5
        let location = button.superview!.convert(NSMakePoint(x, y), to: nil)
        let w = button.window!
        let event = NSEvent.mouseEvent(with: .leftMouseUp,
                                       location: location,
                                       modifierFlags: NSEvent.ModifierFlags(rawValue: 0),
                                       timestamp: 0,
                                       windowNumber: w.windowNumber,
                                       context: w.graphicsContext,
                                       eventNumber: 0,
                                       clickCount: 1,
                                       pressure: 0)!
        NSMenu.popUpContextMenu(appMenu, with: event, for: button)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
        
        // Check if statusbar is full
        guard let button = statusItem?.button else {
            print("Status Bar is full.")
            NSApp.terminate(nil)
            return
        }
        
        button.image = NSImage(named: "LightSwitch-icon")
        button.target = self
        
        if let button = statusItem?.button {
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    // Turn dark mode on/off when user clicks on app icon
    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.leftMouseUp {
            let darkMode = #"tell app "System Events" to tell appearance preferences to set dark mode to not dark mode"#
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: darkMode) {
                if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                    &error) {
                } else if (error != nil) {
                    print("Error: \(String(describing: error))")
                }
            }
        }
        else {
            displayMenu()
        }
    }
}
