//
//  InterpretFromString.swift
//  
//
//  Created by Joseph Hinkle on 6/1/21.
//

import Foundation
import SwiftASTConstructor
import SwiftInterpreter

func interpretFromString(_ code: String) throws -> Any {
    let astData = try SwiftASTConstructor.constructAST(from: code)
    return try SwiftInterpreter.interpret(astData)
}
