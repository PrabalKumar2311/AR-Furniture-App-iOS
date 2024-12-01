//
//  ArViewApp.swift
//  ArView
//
//  Created by Prabal Kumar on 08/10/24.
//

import SwiftUI

@main
struct ArViewApp: App {
    
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
        }
    }
}
