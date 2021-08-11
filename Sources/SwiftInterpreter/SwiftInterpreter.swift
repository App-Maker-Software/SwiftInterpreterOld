#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#elseif canImport(SwiftInterpreterSource)
import SwiftInterpreterSource
#endif

#if canImport(SwiftInterpreterBinary) || canImport(SwiftInterpreterSource)
public func interpret(_ astData: [UInt8], using stack: Stack? = nil) throws -> Any {
    #if canImport(SwiftInterpreterBinary)
    return try SwiftInterpreterBinary.interpret(astData, using: stack)
    #else
    return try SwiftInterpreterSource.interpret(astData, using: stack)
    #endif
}
#endif
