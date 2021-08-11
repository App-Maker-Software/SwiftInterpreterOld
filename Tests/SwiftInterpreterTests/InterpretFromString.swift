//
//  InterpretFromString.swift
//  
//
//  Created by Joseph Hinkle on 6/1/21.
//
#if canImport(SwiftInterpreterBinary) || canImport(SwiftInterpreterSource)
import SwiftASTConstructor
import SwiftInterpreter
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#else
import SwiftInterpreterSource
#endif

var hasSetup = false

@discardableResult
func interpretFromString(_ code: String, using stack: Stack? = nil) throws -> Any {
    if !hasSetup {
        try! unlock_demo(liveAppBundle: nil, connectToHotRefreshServer: false)
        hasSetup = true
    }
    
    let astData = [UInt8](try SwiftASTConstructor.constructAST(from: code))
    return try SwiftInterpreter.interpret(astData, using: stack)
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
