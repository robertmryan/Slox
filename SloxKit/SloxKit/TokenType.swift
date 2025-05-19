//
//  TokenType.swift
//  SloxKit
//
//  Created by Robert Ryan on 5/18/25.
//

import Foundation

enum TokenType {
    // Single-character tokens
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    case comma
    case dot
    case minus
    case plus
    case semicolon
    case slash
    case star

    // One or two character tokens
    case bang
    case bangEqual
    case equal
    case equalEqual
    case greater
    case greaterEqual
    case less
    case lessEqual

    // Literals
    case identifier(String)
    case string(String)
    case number(Double)

    // Keywords
    case and
    case `class`
    case `else`
    case `false`
    case fun
    case `for`
    case `if`
    case `nil`
    case or
    case print
    case `return`
    case `super`
    case this
    case `true`
    case `var`
    case `while`

    case eof
}

extension TokenType {
    static var singleCharacterTokenLookups: [Character: TokenType] = [
        TokenType.leftParen.string!.first!: .leftParen,
        TokenType.rightParen.string!.first!: .rightParen,
        TokenType.leftBrace.string!.first!: .leftBrace,
        TokenType.rightBrace.string!.first!: .rightBrace,
        TokenType.comma.string!.first!: .comma,
        TokenType.dot.string!.first!: .dot,
        TokenType.minus.string!.first!: .minus,
        TokenType.plus.string!.first!: .plus,
        TokenType.semicolon.string!.first!: .semicolon,
        TokenType.star.string!.first!: .star,
    ]

    static var reservedWordTokenLookups: [String: TokenType] = [
        TokenType.and.string!: .and,
        TokenType.`class`.string!: .`class`,
        TokenType.`else`.string!: .`else`,
        TokenType.`false`.string!: .`false`,
        TokenType.fun.string!: .fun,
        TokenType.`for`.string!: .`for`,
        TokenType.`if`.string!: .`if`,
        TokenType.`nil`.string!: .`nil`,
        TokenType.or.string!: .or,
        TokenType.print.string!: .print,
        TokenType.`return`.string!: .`return`,
        TokenType.`super`.string!: .`super`,
        TokenType.this.string!: .this,
        TokenType.`true`.string!: .`true`,
        TokenType.`var`.string!: .`var`,
        TokenType.`while`.string!: .`while`,
    ]

    var string: String? {
        return switch self {
            // Single-character tokens
            case .leftParen: "("
            case .rightParen: ")"
            case .leftBrace: "["
            case .rightBrace: "]"
            case .comma: ","
            case .dot: "."
            case .minus: "-"
            case .plus: "+"
            case .semicolon: ";"
            case .slash: "/"
            case .star: "*"

            // One or two character tokens
            case .bang: "!"
            case .bangEqual: "!="
            case .equal: "="
            case .equalEqual: "=="
            case .greater: ">"
            case .greaterEqual: ">="
            case .less: "<"
            case .lessEqual: "<="

            // Keywords
            case .and: "and"
            case .`class`: "class"
            case .`else`: "else"
            case .`false`: "false"
            case .fun: "fun"
            case .`for`: "for"
            case .`if`: "if"
            case .`nil`: "nil"
            case .or: "or"
            case .print: "print"
            case .`return`: "return"
            case .`super`: "super"
            case .this: "this"
            case .`true`: "true"
            case .`var`: "var"
            case .`while`: "while"

            default: nil
        }
    }
}
