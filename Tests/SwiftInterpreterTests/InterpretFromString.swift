//
//  InterpretFromString.swift
//  
//
//  Created by Joseph Hinkle on 6/1/21.
//
import SwiftASTConstructor
#if canImport(SwiftAST)
import SwiftAST
#endif
#if canImport(SwiftInterpreterBinary) || canImport(SwiftInterpreterSource) || canImport(SwiftInterpreterBinarySource)
import SwiftInterpreter
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#elseif canImport(SwiftInterpreterBinarySource)
import SwiftInterpreterBinarySource
#else
import SwiftInterpreterSource
#endif

var hasSetup = false

@discardableResult
func interpretFromString(_ code: String, using stack: Stack? = nil) throws -> Any {
    let interpreter = SwiftInterpreter.shared
    let astData = try SwiftASTConstructor.constructAST(from: code)
    return try interpreter.interpretSync(astData, in: stack, jobDetails: SwiftInterpreterJob.Details(allowGlobalReturns: true)) as Any
}

typealias Stack = SwiftStack

extension Stack {
    static func createNewBase() -> Stack {
        return Stack()
    }
}

struct NilError: Error {}

extension Optional {
    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let w): return w
        case .none: throw NilError()
        }
    }
}
#endif
