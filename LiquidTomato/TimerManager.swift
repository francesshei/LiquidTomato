//
//  TimerManager.swift
//  LiquidTomato
//
//  Shared observable state for timer management
//

import Foundation
import SwiftUI

enum SessionType {
    case work
    case shortBreak
    case longBreak
}

@Observable
class TimerManager {
    
    var remainingSeconds: Double = 1500.0 // 25 minutes in seconds
    var isRunning: Bool = false
    var isPaused: Bool = false
    
    var currentSession: Int = 1
    var sessionType: SessionType = .work
    
    private var timer: Timer?
    
    private let workDuration: Double = 1500.0      // 25 minutes
    private let shortBreakDuration: Double = 300.0  // 5 minutes
    private let longBreakDuration: Double = 900.0   // 15 minutes
    
    var formattedTime: String {
        let minutes = Int(remainingSeconds) / 60
        let seconds = Int(remainingSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        let totalDuration: Double
        switch sessionType {
        case .work:
            totalDuration = workDuration
        case .shortBreak:
            totalDuration = shortBreakDuration
        case .longBreak:
            totalDuration = longBreakDuration
        }
        return remainingSeconds / totalDuration
    }
    
    // Progress through the 4-session cycle (0.0 to 1.0)
    var pomodoroProgress: Double {
        return Double(currentSession - 1) / 4.0
    }
    
    // Color for the current session type
    var sessionColor: Color {
        switch sessionType {
        case .work:
            return .orange
        case .shortBreak:
            return .green
        case .longBreak:
            return .blue
        }
    }
    
    // Label for the current session type
    var sessionLabel: String {
        switch sessionType {
        case .work:
            return "Focus"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.remainingSeconds -= 1.0
            
            if self.remainingSeconds <= 0 {
                self.completeSession()
            }
        }
        
        timer?.tolerance = 0.1
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = true
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        remainingSeconds = workDuration
        currentSession = 1
        sessionType = .work
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
    }
    
    private func completeSession() {
        stop()
        
        switch sessionType {
        case .work:
            if currentSession == 4 {
                // After 4th work session, long break
                sessionType = .longBreak
                remainingSeconds = longBreakDuration
            } else {
                // Short break
                sessionType = .shortBreak
                remainingSeconds = shortBreakDuration
            }
            
        case .shortBreak:
            currentSession += 1
            sessionType = .work
            remainingSeconds = workDuration
            
        case .longBreak:
            currentSession = 1
            sessionType = .work
            remainingSeconds = workDuration
        }
        
        start()
    }
}
