//
//  PomodoroProgressBar.swift
//  LiquidTomato
//
//  Native macOS-style progress bar for Pomodoro session tracking
//
//  Created by Francesco Sheiban on 15/11/25.
//


import SwiftUI

struct SessionProgressBar: View {
    let currentSession: Int // 1-4
    let totalSessions: Int = 4
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...totalSessions, id: \.self) { session in
                Circle()
                    .fill(session <= currentSession ? Color.white : Color.white.opacity(0.2))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.1))
        )
        .frame(width: 80)
    }
}
