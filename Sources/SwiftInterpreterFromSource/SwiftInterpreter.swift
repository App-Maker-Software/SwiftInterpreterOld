import Foundation
import SwiftInterpreterSource

public func interpret(_ astData: [UInt8]) throws -> Any {
    return try SwiftInterpreterSource.interpret(astData)
}
