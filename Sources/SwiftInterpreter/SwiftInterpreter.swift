import Foundation
#if canImport(SwiftInterpreterSource)
import SwiftInterpreterSource
#endif

public func interpret(_ astData: Data) throws -> Any {
    fatalError(ProcessInfo.processInfo.environment["BUILD_SWIFT_INTERPRETER_FROM_SOURCE"]!)
    #if canImport(SwiftInterpreterSource)
    print(SwiftInterpreterSource.testValue)
    return 0
    #else
    return -1
    #endif
}
