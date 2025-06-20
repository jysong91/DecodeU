//
//  AppView.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI

struct AppView: View {
    enum Tab: String, CaseIterable, Identifiable {
        case decoder = "Decoder"
        case encoder = "Encoder"
        case history = "History"
        var id: String { self.rawValue }
    }

    @State private var selection: Tab = .decoder
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selection) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                }
            }
            .navigationSplitViewColumnWidth(150)
        } detail: {
            switch selection {
            case .decoder:
                DecoderView()
            case .encoder:
                EncoderView()
            case .history:
                HistoryView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    AppView()
}

