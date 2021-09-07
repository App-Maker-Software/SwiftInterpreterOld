#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
let libInterpret = SwiftInterpreterBinary.interpret
#elseif canImport(SwiftInterpreterSource)
import SwiftInterpreterSource
let libInterpret = SwiftInterpreterSource.interpret
#elseif canImport(SwiftInterpreterBinarySource)
import SwiftInterpreterBinarySource
let libInterpret = SwiftInterpreterBinarySource.interpret
#endif

public func interpret(_ astData: [UInt8], using stack: Stack? = nil) throws {
    try libInterpret(astData, stack)
}
