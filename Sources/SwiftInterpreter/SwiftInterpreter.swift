import Foundation
import SwiftInterpreterBinary

public func interpret(_ astData: Data) throws -> Any {
    return try SwiftInterpreterBinary.interpret(astData)
}
