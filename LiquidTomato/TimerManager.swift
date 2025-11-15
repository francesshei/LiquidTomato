//
//  TimerManager.swift
//  LiquidTomato
//
//  Shared observable state implementing timer management
//  Created by Francesco Sheiban on 15/11/25.
//

import Foundation

@Observable
class TimerManager {
    
    var remainingSeconds: Double = 1500.0 // 25 minutes in seconds
    var isRunning: Bool = false
    var isPaused: Bool = false
    
    
    private var timer: Timer?
    
    
    var formattedTime: String {
        let minutes = Int(remainingSeconds) / 60
        let seconds = Int(remainingSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        return remainingSeconds / 1500.0
    }
    

    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.remainingSeconds -= 1.0
            
            if self.remainingSeconds <= 0 {
                self.stop()
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
        remainingSeconds = 1500.0
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
    }
}
