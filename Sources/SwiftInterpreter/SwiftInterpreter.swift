import Foundation
#if canImport(SwiftInterpreterSource)
import SwiftInterpreterSource
#endif
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#endif
#if canImport(SwiftInterpreterBinary) && canImport(SwiftInterpreterSource)
#error("only either SwiftInterpreterBinary or SwiftInterpreterSource should be included in build")
#endif

public func interpret(_ astData: Data) throws -> Any {
    #if canImport(SwiftInterpreterSource)
    return try SwiftInterpreterSource.interpret(astData)
    #elseif canImport(SwiftInterpreterBinary)
    return try SwiftInterpreterBinary.interpret(astData)
    #else
    #error("no swift interpreter found")
    #endif
}
