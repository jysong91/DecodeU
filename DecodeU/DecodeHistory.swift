//
//  DecodeHistory.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI
import SwiftData

@Model
class DecodeHistory: Identifiable {
    var input: String
    var result: String
    var date: Date

    init(input: String, result: String, date: Date = .now) {
        self.input = input
        self.result = result
        self.date = date
    }
}
