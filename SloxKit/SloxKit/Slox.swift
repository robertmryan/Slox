//
//  Slox.swift
//  SloxKit
//
//  Created by Robert Ryan on 5/18/25.
//

import Foundation

public actor Slox {
    public init() {
        // This is intentionally blank
    }

    public func results(for line: String) -> any AsyncSequence<Token, any Error> {
        let scanner = Scanner(source: line)
        let tokens = scanner.scanTokens()
        return AsyncThrowingStream { continuation in
            for token in tokens {
                continuation.yield(token)
            }
            continuation.finish()
        }
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

public enum SloxError: Error {
    case parse(line: Int, message: String)
    case unexpectedCharacter(line: Int)
    case unterminatedString(line: Int)
}

extension SloxError: LocalizedError {
    public var errorDescription: String? {
        return switch self {
            case .parse(line: let line, message: let message): "Parse error at line \(line): \(message)"
            case .unexpectedCharacter(line: let line):         "Unexpected character at line \(line)"
            case .unterminatedString(line: let line):          "Unterminated string at line \(line)"
        }
    }
}
