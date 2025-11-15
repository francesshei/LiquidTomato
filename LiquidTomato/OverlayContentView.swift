//
//  OverlayContentView.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//

import SwiftUI

struct OverlayContentView: View {
    let timerManager: TimerManager
    let frameSideLength = 95.0
    
    var body: some View {
        ZStack {
            // Circular progress ring with color-coded session type
            CircularProgressRing(
                progress: timerManager.progress,
                color: timerManager.sessionColor
            )
            .frame(width: frameSideLength, height: frameSideLength)
            
            // Session label, timer text, and progress bar in center
            VStack(spacing: 2) {
                // Session type label (small, above timer)
                Text(timerManager.sessionLabel)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 8, weight: .medium, design: .default))
                    .textCase(.uppercase)
                    .kerning(0.5)
                
                // Timer text
                Text(timerManager.formattedTime)
                    .foregroundColor(.white)
                    .font(.system(size: 28, weight: .thin, design: .default))
                    .monospacedDigit()
                    .fixedSize()
                
                // Pomodoro session progress bar
                SessionProgressBar(currentSession: timerManager.currentSession)
                    .padding(.top, 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.regular.interactive())
    }
}
