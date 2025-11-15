//
//  OverlayContentView.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//

import SwiftUI

struct OverlayContentView: View {
    @State private var timerDuration: Double = 30.0
    
    var body: some View {
        VStack {
            Text("Hello world")
                .foregroundColor(.white)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.clear.interactive())
    }
    
    func updateTimer(duration: Double) {
        timerDuration = duration
    }
}
