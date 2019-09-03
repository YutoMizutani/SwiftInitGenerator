//
//  SwiftInitGenerator.swift
//  SwiftInitGenerator
//
//  Created by ym on 2019/03/18.
//  Copyright © 2019 Yuto Mizutani. All rights reserved.
//

import Foundation

public struct SwiftInitGenerator {
    public func generate(_ str: String) -> String {
        return str
            .translatedSemiColonsToLine()
            .separatedLines()
            .map { $0.translateStackContent() }
            .filter { $0 != nil }.map { $0! }
            .translateInitializer()
    }
}

typealias Settings = InitGeneratorSettings
public enum InitGeneratorSettings: String, CaseIterable {
    public static let lineString: String = "\n"

    case privateLet = "private let"
    case privateVar = "private var"
    case filePrivateLet = "fileprivate let"
    case filePrivateVar = "fileprivate var"
    case `let`
    case `var`
    case publicLet = "public let"
    case publicVar = "public var"
    case openLet = "open let"
    case openVar = "open var"

    case privateStaticLet = "private static let"
    case privateStaticVar = "private static var"
    case filePrivateStaticLet = "fileprivate static let"
    case filePrivateStaticVar = "fileprivate static var"
    case staticLet = "static let"
    case staticVar = "static var"
    case publicStaticLet = "public static let"
    case publicStaticVar = "public static var"
    case openStaticLet = "open static let"
    case openStaticVar = "open static var"

    case privateClassLet = "private class let"
    case privateClassVar = "private class var"
    case filePrivateClassLet = "fileprivate class let"
    case filePrivateClassVar = "fileprivate class var"
    case classLet = "class let"
    case classVar = "class var"
    case publicClassLet = "public class let"
    case publicClassVar = "public class var"
    case openClassLet = "open class let"
    case openClassVar = "open class var"
}

public struct StackContent {
    public var name: String
    public var type: String
}

public extension String {
    /// セミコロンを改行
    func translatedSemiColonsToLine() -> String {
        return replacingOccurrences(of: ";\n", with: Settings.lineString)
            .replacingOccurrences(of: ";", with: Settings.lineString)
    }

    /// 改行ごとにArrayにする
    func separatedLines() -> [String] {
        return components(separatedBy: Settings.lineString)
            .map { String($0) }
            .filter { !$0.isEmpty }
    }

    func getVariable() -> String {
        let removedSpaces = replacingOccurrences(of: " ", with: "")
        for prefix in Settings.allCases
            .map({ $0.rawValue.replacingOccurrences(of: " ", with: "") }) {
            if removedSpaces.count >= prefix.count + 2 {
                if removedSpaces.hasPrefix(prefix) {
                    return String(removedSpaces.dropFirst(prefix.count))
                }
            }
        }
        return ""
    }

    func translateStackContent() -> StackContent? {
        let variableName = getVariable()
        guard !variableName.isEmpty else { return nil }
        let splitted = variableName.split(separator: ":", maxSplits: 1)
        guard splitted.count == 2 else { return nil }
        let name: String = String(splitted[0])
        let type: String = String(splitted[1])
        return StackContent(name: name, type: type)
    }

    func removedLast(_ i: Int = 1) -> String {
        guard count >= i else { return "" }
        return String(prefix(count - i))
    }
}

public extension Array where Element == String {
    /// 改行してマージする
    func mergedLines() -> String {
        return joined(separator: Settings.lineString)
    }
}

public extension Array where Element == StackContent {
    func translateInitializer() -> String {
        return "init(\(map { "\($0.name): \($0.type),\n" }.joined().removedLast(2))) {\n\(map { "self.\($0.name) = \($0.name)\n" }.joined())}"
    }
}
