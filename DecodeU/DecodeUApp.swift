//
//  DecodeUApp.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI
import SwiftData

@main
struct DecodeUApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: DecodeHistory.self)
    }
}
