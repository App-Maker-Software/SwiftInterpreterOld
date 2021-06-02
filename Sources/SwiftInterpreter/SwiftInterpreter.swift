import SwiftInterpreterBinary

public func interpret(_ astData: [UInt8]) throws -> Any {
    return try SwiftInterpreterBinary.interpret(astData)
}
