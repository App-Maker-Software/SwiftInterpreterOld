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
typealias SwiftInterpreterJob = SwiftInterpreterBinary.SwiftInterpreterJob
#elseif canImport(SwiftInterpreterPrivate)
import SwiftInterpreterPrivate
typealias AMStructView = SwiftInterpreterPrivate.AMStructView
typealias SwiftInterpreterJob = SwiftInterpreterPrivate.SwiftInterpreterJob
#elseif canImport(SwiftInterpreterBinarySource)
import SwiftInterpreterBinarySource
typealias AMStructView = SwiftInterpreterBinarySource.AMStructView
typealias SwiftInterpreterJob = SwiftInterpreterBinarySource.SwiftInterpreterJob
#else
import SwiftInterpreterSource
typealias AMStructView = SwiftInterpreterSource.AMStructView
typealias SwiftInterpreterJob = SwiftInterpreterSource.SwiftInterpreterJob
#endif
import SwiftUI

@available(iOS 13, macOS 10.5, *)
extension AMStructView: Inspectable {}

@available(iOS 13, macOS 10.5, *)
extension AnyShape: InspectableShape, Inspectable {}
