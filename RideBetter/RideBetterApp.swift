//
//  RideBetterApp.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-10.
//

import SwiftUI

@main
struct RideBetterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
