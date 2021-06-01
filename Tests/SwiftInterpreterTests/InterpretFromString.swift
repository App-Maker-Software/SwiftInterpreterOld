//
//  InterpretFromString.swift
//  
//
//  Created by Joseph Hinkle on 6/1/21.
//

let testSource: TestSource = .SourceCode

enum TestSource {
    case SourceCode
    case LocalBinary
    case RemoteBinary
}

import Foundation
import SwiftASTConstructor
#if canImport(SwiftInterpreterFromSource)
import SwiftInterpreterFromSource
#endif
#if canImport(SwiftInterpreterLocalBinary)
import SwiftInterpreterLocalBinary
#endif
import SwiftInterpreter


func interpretFromString(_ code: String) throws -> Any {
    let astData = [UInt8](try SwiftASTConstructor.constructAST(from: code))
    #if DEBUG
    switch testSource {
    
    }
    #endif
    #if canImport(SwiftInterpreterFromSource)
    return try SwiftInterpreterFromSource.interpret(astData)
    #elseif canImport(SwiftInterpreterLocalBinary)
    return try SwiftInterpreterLocalBinary.interpret(astData)
    #else
    return try SwiftInterpreter.interpret(astData)
    #endif
}
