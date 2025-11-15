//
//  LiquidTomatoApp.swift
//  LiquidTomato
//
//  Created by Francesco Sheiban on 05/11/25.
//

import SwiftUI

@main
struct LiquidTomatoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
