//
//  SloxKit.swift
//  SloxKit
//
//  Created by Robert Ryan on 5/18/25.
//

import Foundation

public actor Slox {
    public init() {
        // This is intentionally blank
    }

    public func results(for line: String) -> any AsyncSequence<String, any Error> {
        tokens(for: line) // for now, just return tokens
    }
}

private extension Slox {
    func tokens(for line: String) -> any AsyncSequence<String, any Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                let lines = line.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }

                do {
                    for line in lines {
                        try await Task.sleep(for: .seconds(1))
                        continuation.yield(line)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { state in
                if case .cancelled = state {
                    task.cancel()
                }
            }
        }
    }
}
