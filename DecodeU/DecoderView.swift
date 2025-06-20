//
//  ContentView.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI
import SwiftData

struct DecoderView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var input = ""
    @State private var output = ""
    @State private var isHorizontalLayout = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\u{1F4D6} Unicode Escape Decoder")
                    .font(.title2)
                    .bold()
                Spacer()
                Toggle("Horizontal View", isOn: $isHorizontalLayout)
                    .toggleStyle(.switch)
            }

            if isHorizontalLayout {
                HStack(spacing: 12) {
                    inputEditor
                    outputView
                }
            } else {
                VStack(spacing: 12) {
                    inputEditor
                    outputView
                }
            }

            Spacer()
        }
        .padding()
        .onChange(of: input) {
            output = decodeUnicode(from: input)
            let newEntry = DecodeHistory(input: input, result: output)
            modelContext.insert(newEntry)
        }
    }

    var inputEditor: some View {
        VStack(alignment: .leading) {
            Text("Input:")
            TextEditor(text: $input)
                .font(.system(.body, design: .monospaced))
                .border(Color.gray.opacity(0.3), width: 1)
                .frame(minHeight: 100)
        }
    }

    var outputView: some View {
        VStack(alignment: .leading) {
            Text("Decoded Output:")
            ScrollView {
                Text(output)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .frame(minHeight: 100)
        }
    }

    func decodeUnicode(from escapedString: String) -> String {
        let pattern = #"\\u([0-9a-fA-F]{4})"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = escapedString as NSString
        var result = escapedString

        let matches = regex?.matches(in: escapedString, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []

        for match in matches.reversed() {
            if let range = Range(match.range(at: 1), in: escapedString) {
                let hexString = String(escapedString[range])
                if let scalar = UnicodeScalar(UInt32(hexString, radix: 16)!) {
                    let char = String(scalar)
                    let fullRange = match.range(at: 0)
                    result = (result as NSString).replacingCharacters(in: fullRange, with: char)
                }
            }
        }
        return result
    }
}

#Preview {
    DecoderView()
}
