//
//  Scanner.swift
//  SloxKit
//
//  Created by Robert Ryan on 5/18/25.
//

import Foundation

public class Scanner {
    private let source: String
    private var tokens: [Token] = []
    private var errors: [any Error] = []

    private var start: String.Index
    private var current: String.Index
    private var line = 1

    public init(source: String) {
        self.source = source
        self.start = source.startIndex
        self.current = source.startIndex
    }

    public func scanTokens() -> [Token] {
        while !isAtEnd {
            // We are at the beginning of the next lexeme
            start = current
            scanToken()
        }

        tokens.append(Token(type: .eof, lexeme: "", line: line))
        return tokens
    }
}

private extension Scanner {
    var isAtEnd: Bool {
        current >= source.endIndex
    }

    @discardableResult
    func advance() -> Character {
        defer { current = source.index(after: current) }
        return source[current]
    }

    func addToken(_ type: TokenType) {
        let text = String(source[start..<current])
        tokens.append(Token(type: type, lexeme: text, line: line))
    }

    func match(_ expected: Character) -> Bool {
        if isAtEnd || source[current] != expected { return false }

        advance()
        return true
    }

    func peek() -> Character {
        if isAtEnd { return "\0" }
        return source[current]
    }

    func peekNext() -> Character {
        let nextIndex = source.index(after: current)

        if nextIndex >= source.endIndex { return "\0" }

        return source[nextIndex]
    }

    func string() {
        while peek() != "\"", !isAtEnd {
            if peek() == "\n" { line += 1 }
            advance()
        }

        if isAtEnd {
            errors.append(SloxError.unexpectedCharacter(line: line))
            return
        }

        // The closing quotation mark
        advance()

        // Trim the surrounding quotes
        let value = String(source[source.index(after: current) ..< current])
        addToken(.string(value))
    }

    func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }

    func number() {
        while isDigit(peek()) { advance() }

        // Look for a fractional part.
        if peek() == ".", isDigit(peekNext()) {
            // Consume the "."
            advance()

            while isDigit(peek()) { advance() }
        }

        let numberString = String(source[start ..< current])
        let number = Double(numberString) ?? .nan

        addToken(.number(number))
    }

    func isAlpha(_ c: Character) -> Bool {
        return
            (c >= "a" && c <= "z") ||
            (c >= "A" && c <= "Z") ||
            c == "_"
    }

    func isAlphaNumeric(_ c: Character) -> Bool {
        return isAlpha(c) || isDigit(c)
    }

    func identifier() {
        while isAlphaNumeric(peek()) { advance() }

        let text = String(source[start ..< current])
        if let type = TokenType.reservedWordTokenLookups[text] {
            addToken(type)
        } else {
            addToken(.identifier(text))
        }
    }

    func scanToken() {
        let c = advance()

        if let token = TokenType.singleCharacterTokenLookups[c] {
            addToken(token)
            return
        }

        switch c {
            case "!": addToken(match("=") ? .bangEqual : .bang)
            case "=": addToken(match("=") ? .equalEqual : .equal)
            case "<": addToken(match("=") ? .lessEqual : .less)
            case ">": addToken(match("=") ? .greaterEqual : .greater)

            case "/":
                if match("/") {
                    // A comment goes until the end of the line
                    while peek() != "\n", !isAtEnd {
                        advance()
                    }
                } else {
                    addToken(.slash)
                }

            case " ", "\r", "\t":
                // Ignore whitespace
                break

            case "\n": line += 1

            case let c where isDigit(c): number()

            case let c where isAlpha(c): identifier()

            default: errors.append(SloxError.unexpectedCharacter(line: line))
        }
    }
}
