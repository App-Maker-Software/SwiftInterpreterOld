// re-export symbols
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
public typealias SwiftInterpreter = SwiftInterpreterBinary.SwiftInterpreter
#elseif canImport(SwiftInterpreterSource)
import SwiftInterpreterSource
public typealias SwiftInterpreter = SwiftInterpreterSource.SwiftInterpreter
#elseif canImport(SwiftInterpreterBinarySource)
import SwiftInterpreterBinarySource
public typealias SwiftInterpreter = SwiftInterpreterBinarySource.SwiftInterpreter
#endif
