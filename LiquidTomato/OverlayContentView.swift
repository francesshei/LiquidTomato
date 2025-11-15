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
            // Circular progress ring
            CircularProgressRing(progress: timerManager.progress)
                .frame(width: 145, height: 145)
                .padding(10)
            
            // Timer text in center
            VStack {
                Text(timerManager.formattedTime)
                    .foregroundColor(.white)
                    .font(.system(size: 48, weight: .thin, design: .default))
                    .monospacedDigit()
                    .fixedSize()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.clear.interactive())
    }
}
