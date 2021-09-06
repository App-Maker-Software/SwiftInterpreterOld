//
//  Inspectables.swift
//  SwiftUIInterpreterTests
//
//  Created by Joseph Hinkle on 3/18/21.
//

import ViewInspector
#if canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#elseif canImport(SwiftInterpreterPrivate)
import SwiftInterpreterPrivate
#else
import SwiftInterpreterSource
#endif
import SwiftUI

@available(iOS 13, macOS 10.5, *)
extension AMStructView: Inspectable {}

@available(iOS 13, macOS 10.5, *)
extension AnyShape: InspectableShape, Inspectable {}
