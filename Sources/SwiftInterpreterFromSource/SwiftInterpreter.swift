import Foundation
import SwiftInterpreterSource

public func interpret(_ astData: Data) throws -> Any {
    return try SwiftInterpreterSource.interpret(astData)
}
