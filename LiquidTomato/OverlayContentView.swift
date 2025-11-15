//
//  OverlayContentView.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//

import SwiftUI

struct OverlayContentView: View {
    let timerManager: TimerManager
    
    var body: some View {
        ZStack {
            // Circular progress ring with color-coded session type
            CircularProgressRing(
                progress: timerManager.progress,
                color: timerManager.sessionColor
            )
            .frame(width: 145, height: 145)
            .padding(10)
            
            // Session label, timer text, and progress bar in center
            VStack(spacing: 6) {
                // Session type label (small, above timer)
                Text(timerManager.sessionLabel)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .textCase(.uppercase)
                    .kerning(0.5)
                
                // Timer text
                Text(timerManager.formattedTime)
                    .foregroundColor(.white)
                    .font(.system(size: 48, weight: .thin, design: .default))
                    .monospacedDigit()
                    .fixedSize()
                
                // Pomodoro session progress bar
                SessionProgressBar(currentSession: timerManager.currentSession)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.clear.interactive())
    }
}
