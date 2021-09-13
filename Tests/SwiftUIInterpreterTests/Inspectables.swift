//
//  Inspectables.swift
//  SwiftUIInterpreterTests
//
//  Created by Joseph Hinkle on 3/18/21.
//

import ViewInspector
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
typealias AMStructView = SwiftInterpreterBinary.AMStructView
#elseif canImport(SwiftInterpreterPrivate)
import SwiftInterpreterPrivate
typealias AMStructView = SwiftInterpreterPrivate.AMStructView
#elseif canImport(SwiftInterpreterBinarySource)
import SwiftInterpreterBinarySource
typealias AMStructView = SwiftInterpreterBinarySource.AMStructView
#else
import SwiftInterpreterSource
typealias AMStructView = SwiftInterpreterSource.AMStructView
#endif
import SwiftUI

@available(iOS 13, macOS 10.5, *)
extension AMStructView: Inspectable {}

@available(iOS 13, macOS 10.5, *)
extension AnyShape: InspectableShape, Inspectable {}
