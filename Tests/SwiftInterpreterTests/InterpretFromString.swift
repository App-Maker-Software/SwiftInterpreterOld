//
//  InterpretFromString.swift
//  
//
//  Created by Joseph Hinkle on 6/1/21.
//

import Foundation
import SwiftASTConstructor
#if canImport(SwiftInterpreterFromSource)
import SwiftInterpreterFromSource
#elseif canImport(SwiftInterpreterLocalBinary)
import SwiftInterpreterLocalBinary
#else
import SwiftInterpreter
#endif


func interpretFromString(_ code: String) throws -> Any {
    let astData = [UInt8](try SwiftASTConstructor.constructAST(from: code))
    #if canImport(SwiftInterpreterFromSource)
    return try SwiftInterpreterFromSource.interpret(astData)
    #elseif canImport(SwiftInterpreterLocalBinary)
    return try SwiftInterpreterLocalBinary.interpret(astData)
    #else
    return try SwiftInterpreter.interpret(astData)
    #endif
}
