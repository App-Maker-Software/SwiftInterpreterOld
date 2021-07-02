#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#else
import SwiftInterpreterSource
#endif

public func interpret(_ astData: [UInt8], using stack: Stack? = nil) throws -> Any {
//    return try SwiftInterpreterBinary.interpret(astData, using: stack)
    return try SwiftInterpreterSource.interpret(astData, using: stack)
}
