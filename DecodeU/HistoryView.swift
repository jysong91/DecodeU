//
//  HistoryView.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DecodeHistory.date, order: .reverse) private var historyItems: [DecodeHistory]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Decode History")
                    .font(.title2)
                    .bold()
                Spacer()
                Button("Clear All", role: .destructive) {
                    for item in historyItems {
                        modelContext.delete(item)
                    }
                }
                .disabled(historyItems.isEmpty)
            }
            List {
                ForEach(historyItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.result)
                            .font(.body)
                        Text(item.input)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text(item.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(historyItems[index])
                    }
                }
            }
        }
        .padding()
    }
}
