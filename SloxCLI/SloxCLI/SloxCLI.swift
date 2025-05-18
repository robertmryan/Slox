//
//  SloxCLI.swift
//  slox
//
//  Created by Robert Ryan on 5/18/25.
//

import Foundation
import SloxKit

@main
struct SloxCLI {
    static func main() async {
        do {
            try await run()
        } catch {
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }
}

private extension SloxCLI {
    static func run() async throws {
        let lox = Slox()

        var iterator = FileHandle.standardInput.bytes.lines.makeAsyncIterator()

        while true {
            printPrompt()

            guard let line = try await iterator.next() else { break }

            for try await output in await lox.results(for: line) {
                print(output)
            }
        }
    }

    static func printPrompt() {
        FileHandle.standardOutput.write(Data(("> ").utf8))
    }
}
