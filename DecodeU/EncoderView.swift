//
//  EncoderView.swift
//  DecodeU
//
//  Created by Song Jin Young on 6/20/25.
//

import SwiftUI

struct EncoderView: View {
    @State private var input = ""
    @State private var output = ""
    @State private var isHorizontalLayout = false
    @State private var showCopiedToast = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\u{1F4DD} Unicode Escape Encoder")
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
            output = encodeToUnicode(from: input)
        }
        .overlay(alignment: .bottomTrailing) {
            if showCopiedToast {
                Text("Copied!")
                    .padding(10)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .transition(.opacity)
            }
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
            Text("Encoded Output:")
            ScrollView {
                Text(output)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .onTapGesture {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(output, forType: .string)
                        withAnimation {
                            showCopiedToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showCopiedToast = false
                            }
                        }
                    }
            }
            .frame(minHeight: 100)
        }
    }

    func encodeToUnicode(from string: String) -> String {
        return string.unicodeScalars.map { scalar in
            if scalar.isASCII {
                return String(scalar)
            } else {
                return String(format: "\\u%04X", scalar.value)
            }
        }.joined()
    }
}
