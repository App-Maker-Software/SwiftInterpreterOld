#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#else
import SwiftInterpreterSource
#endif

public func interpret(_ astData: [UInt8], using stack: Stack? = nil) throws -> Any {
    #if canImport(SwiftInterpreterBinary)
    return try SwiftInterpreterBinary.interpret(astData, using: stack)
    #else
    return try SwiftInterpreterSource.interpret(astData, using: stack)
    #endif
}
