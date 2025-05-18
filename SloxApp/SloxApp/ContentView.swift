//
//  ContentView.swift
//  SloxApp
//
//  Created by Robert Ryan on 5/18/25.
//

import SwiftUI
import AsyncAlgorithms
import SloxKit

struct ContentView: View {
    @State private var input = ""
    @State private var priorInput = ""
    @State private var output = ""
    @State private var error: (any Error)?
    @State private var isButtonTapped = false
    @State private var isRunning = false

    private let lox = Slox()
    private let inputChannel = AsyncChannel<String>()

    var body: some View {
        VStack {
            if let error {
                Text(error.localizedDescription)
            }
            HStack {
                TextField("Enter command", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onSubmit {
                        isButtonTapped = true
                    }

                Button("Go") {
                    isButtonTapped = true
                }
                .disabled(isRunning)

                Text(output)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(input == priorInput ? Color.primary : .secondary)
            }
        }
        .task {
            for await line in inputChannel {
                await process(line)
            }
        }
        .task(id: isButtonTapped) {
            guard isButtonTapped else { return }
            await inputChannel.send(input)
            isButtonTapped = false
        }
        .padding()
    }
}

private extension ContentView {
    private func process(_ line: String) async {
        output = ""
        priorInput = line
        isRunning = true

        do {
            for try await line in await lox.results(for: input) {
                output += line + "\n"
            }
        } catch {
            self.error = error
        }

        isRunning = false
    }
}

#Preview {
    ContentView()
}
