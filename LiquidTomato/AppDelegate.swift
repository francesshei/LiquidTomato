//
//  AppDelegate.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//


import SwiftUI
import AppKit

// Define a custom class that can be set to receive keyboard events
class KeyablePanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var statusItem: NSStatusItem?
    
    // Using the observable timer manager
    let timerManager = TimerManager()
    let panelSize = 105.0
    
    // Store reference to the menu item to update its title
    var startResumeMenuItem: NSMenuItem?
    
    // Event monitor for keyboard shortcuts when panel is focused
    var keyEventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: 18)
        if let button = statusItem?.button {
                button.image = NSImage(named: "MenuBarIcon")
                button.image?.size = NSSize(width: 18, height: 18)
                button.image?.isTemplate = true
        }
        
        // Create the menu
        let menu = NSMenu()
        
        // Store reference to update title dynamically
        startResumeMenuItem = NSMenuItem(title: "Start", action: #selector(openApp), keyEquivalent: "s")
        menu.addItem(startResumeMenuItem!)
        
        menu.addItem(NSMenuItem(title: "Pause", action: #selector(pauseTimer), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "Reset", action: #selector(resetTimer), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        // Assign the menu to the status item
        statusItem?.menu = menu
        
        // Update menu item title based on timer state
        updateMenuItemTitle()
        
        // Set up keyboard shortcuts for when panel is focused
        setupKeyboardShortcuts()
    }
    
    // Calculate panel position for top-right corner of the given screen
    func topRightPosition(on screen: NSScreen? = NSScreen.main) -> CGPoint {
        guard let screen = screen else {
            // Fallback to center if no screen available
            return CGPoint(x: 200, y: 200)
        }

        let screenFrame = screen.visibleFrame // Excludes menu bar and dock
        let padding = 20.0

        let x = screenFrame.maxX - panelSize - padding
        let y = screenFrame.maxY - panelSize - padding
        return CGPoint(x: x, y: y)
    }
    
    @objc func openApp() {
        // Prevent multiple windows from stacking up
        if window == nil || !window.isVisible {
            // Get dynamic position for top-right corner
            let position = topRightPosition()
            
            // Create panel only if it doesn't exist
            let panel = KeyablePanel(
                contentRect: NSRect(
                    x: position.x,
                    y: position.y,
                    width: panelSize,
                    height: panelSize
                ),
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
            panel.ignoresMouseEvents = false
            panel.isMovable = true
            panel.isMovableByWindowBackground = true
            panel.hasShadow = false
            
            
            let contentView = OverlayContentView(timerManager: timerManager)
                .clipShape(Circle())
            let hostingView = NSHostingView(rootView: contentView)
            hostingView.focusRingType = .none
            panel.contentView = hostingView
            
            panel.orderFrontRegardless()
            panel.makeKey() // Make the panel the key window
            window = panel
        } else {
            // If panel exists, make it key again
            window.makeKey()
        }
        
        // Start or resume the timer based on current state
        if timerManager.isPaused {
            timerManager.start() // This resumes from paused state
        } else if !timerManager.isRunning {
            timerManager.start() // This starts fresh
        }
        
        updateMenuItemTitle()
    }
    
    @objc func pauseTimer() {
        timerManager.pause()
        updateMenuItemTitle()
    }
    
    @objc func resetTimer() {
        timerManager.reset()
        updateMenuItemTitle()
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
  
    // Sets up local event monitor to handle keyboard shortcuts when panel is focused
    private func setupKeyboardShortcuts() {
        keyEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self,
                  let window = self.window,
                  window.isKeyWindow else {
                return event
            }
            
            // Check for Command key modifier
            guard event.modifierFlags.contains(.command) else {
                return event
            }
            
            // Handle keyboard shortcuts
            switch event.charactersIgnoringModifiers?.lowercased() {
            case "s":
                self.openApp()
                return nil // Event handled
            case "p":
                self.pauseTimer()
                return nil // Event handled
            case "r":
                self.resetTimer()
                return nil // Event handled
            case "q":
                self.quitApp()
                return nil // Event handled
            default:
                return event // Pass through unhandled events
            }
        }
    }
    
    // Update menu item title based on timer state
    private func updateMenuItemTitle() {
        if timerManager.isPaused {
            startResumeMenuItem?.title = "Resume"
        } else {
            startResumeMenuItem?.title = "Start"
        }
    }
    

    deinit {
        if let monitor = keyEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
