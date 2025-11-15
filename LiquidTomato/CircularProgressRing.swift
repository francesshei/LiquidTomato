//
//  CircularProgressRing.swift
//  LiquidTomato
//
//  Progress ring matching macOS native Timer design
//
//  Created by Francesco Sheiban on 15/11/25.
//


import SwiftUI

struct CircularProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let color: Color
    let lineWidth: CGFloat = 3.0
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    Color.white.opacity(0.15),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeOut(duration: 0.3), value: progress)
        }
    }
}
