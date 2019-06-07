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
public struct InitGeneratorSettings {
    public static let lineString: String = "\n"

    /// let
    static let letText: String = "let"
    /// var
    static let variableText: String = "var"
}

public struct StackContent {
    public var name: String
    public var type: String
}

public extension String {
    /// セミコロンを改行
    public func translatedSemiColonsToLine() -> String {
        return replacingOccurrences(of: ";\n", with: Settings.lineString)
            .replacingOccurrences(of: ";", with: Settings.lineString)
    }

    /// 改行ごとにArrayにする
    public func separatedLines() -> [String] {
        return components(separatedBy: Settings.lineString)
            .map { String($0) }
    }

    public func decisionVariable() -> Bool {
        let removedSpaces = replacingOccurrences(of: " ", with: "")
        if removedSpaces.count >= Settings.letText.count + 2 {
            if removedSpaces.hasPrefix(Settings.letText) {
                return true
            }
        }
        if removedSpaces.count >= Settings.variableText.count + 2 {
            if removedSpaces.hasPrefix(Settings.variableText) {
                return true
            }
        }
        return false
    }

    public func translateStackContent() -> StackContent? {
        guard decisionVariable() else { return nil }
        let splitted = split(separator: " ")
        guard splitted.count == 3 && splitted[1].hasSuffix(":") else { return nil }
        let name: String = String(splitted[1]).removedLast(1)
        let type: String = String(splitted[2])
        return StackContent(name: name, type: type)
    }

    public func removedLast(_ i: Int = 1) -> String {
        return String(prefix(count - i))
    }
}

public extension Array where Element == String {
    /// 改行してマージする
    public func mergedLines() -> String {
        return joined(separator: Settings.lineString)
    }
}

public extension Array where Element == StackContent {
    public func translateInitializer() -> String {
        return "init(\(map { "\($0.name): \($0.type),\n" }.joined().removedLast(2))) {\n\(map { "self.\($0.name) = \($0.name)\n" }.joined())}"
    }
}

var text = """
class User: Equatable {
var id: UUID;
var name: String?;var favorited: Bool
}
"""

let result = text
    .translatedSemiColonsToLine()
    .separatedLines()
    .map { $0.translateStackContent() }
    .filter { $0 != nil }.map { $0! }
    .translateInitializer()

print(result)

var exeption = """
init(id: UUID,
name: String?,
favorited: Bool) {
self.id = id
self.name = name
self.favorited = favorited
}
"""

print(result == exeption)
