//
//  AppDelegate.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//


import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var statusItem: NSStatusItem?
    
    // Using the observable timer manager
    let timerManager = TimerManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "LT"
        
        // Create the menu
        let menu = NSMenu()
                
        // Add menu items
        menu.addItem(NSMenuItem(title: "Start/Stop", action: #selector(openApp), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "Pause", action: #selector(pauseTimer), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "Reset", action: #selector(resetTimer), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
                
        // Assign the menu to the status item
        statusItem?.menu = menu
    }
    
    @objc func openApp() {
        // Handle open action
        let panel = NSPanel(
            contentRect: NSRect(x: 200, y: 200, width: 165, height: 165),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.isFloatingPanel = true
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hidesOnDeactivate = false
        // Enables mouse interactions
        panel.ignoresMouseEvents = false
        // Enables moving it around the window
        panel.isMovable = true
        panel.isMovableByWindowBackground = true
        // Remove the black border
        panel.hasShadow = false
        
        let contentView = OverlayContentView(timerManager: timerManager)
        panel.contentView = NSHostingView(rootView: contentView)
        
        panel.orderFrontRegardless()
        window = panel
        
        // Start the timer when the panel is opened
        timerManager.start()
    }
        
    @objc func pauseTimer() {
        timerManager.pause()
    }
    
    @objc func resetTimer() {
        timerManager.reset()
    }
        
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
