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

    func decodeUnicode(from rawInput: String) -> String {
        var input = rawInput.replacingOccurrences(of: #"\\u"#, with: #"\u"#)
                            .replacingOccurrences(of: #"\\U"#, with: #"\U"#)

        // \UXXXX to \U0000XXXX
        let shortPattern = #"\\U([0-9a-fA-F]{4})(?![0-9a-fA-F])"#
        let shortRegex = try? NSRegularExpression(pattern: shortPattern)
        let matches = shortRegex?.matches(in: input, range: NSRange(location: 0, length: input.utf16.count)) ?? []
        for match in matches.reversed() {
            if let range = Range(match.range(at: 1), in: input) {
                let padded = "0000" + input[range]
                input = (input as NSString).replacingCharacters(in: match.range(at: 1), with: padded)
            }
        }

        return decodeUnicodeStrict(from: input)
    }

    func decodeUnicodeStrict(from escapedString: String) -> String {
        var result = escapedString

        // \UXXXXXXXX
        let pattern32 = #"\\U([0-9a-fA-F]{8})"#
        let regex32 = try? NSRegularExpression(pattern: pattern32)
        let matches32 = regex32?.matches(in: result, range: NSRange(location: 0, length: (result as NSString).length)) ?? []
        for match in matches32.reversed() {
            if let range = Range(match.range(at: 1), in: result),
               let scalar = UInt32(result[range], radix: 16),
               let unicode = UnicodeScalar(scalar) {
                result = (result as NSString).replacingCharacters(in: match.range, with: String(unicode))
            }
        }

        // \uXXXX
        let pattern16 = #"\\u([0-9a-fA-F]{4})"#
        let regex16 = try? NSRegularExpression(pattern: pattern16)
        let matches16 = regex16?.matches(in: result, range: NSRange(location: 0, length: (result as NSString).length)) ?? []
        for match in matches16.reversed() {
            if let range = Range(match.range(at: 1), in: result),
               let scalar = UInt32(result[range], radix: 16),
               let unicode = UnicodeScalar(scalar) {
                result = (result as NSString).replacingCharacters(in: match.range, with: String(unicode))
            }
        }

        return result
    }
}
