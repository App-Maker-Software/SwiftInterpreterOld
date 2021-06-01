//
// THIS FILE IS AUTOMATICALLY GENERATED BY build_automatic_tets.py
// DO NOT EDIT THIS FILE
//

import XCTest
@testable import SwiftInterpreter

#if !canImport(ObjectiveC)
final class SwiftInterpreterAutomaticTests {
    public static let testCases: [XCTestCaseEntry] = [
        testCase(Example.allTests),
    ]
}
#endif

final class Example: XCTestCase {

    func testSomething() throws {
        let interpretedReturnResult = try interpretFromString("""
            //
            // start interpreted section
            //
            return 0
            
            //
            // end interpreted section
            //
        """) as Any
        func testRealSwift() -> Any {
            //
            // start compiled section
            //
            return 0
            
            //
            // end compiled section
            //
        }
        let realResult = testRealSwift()
        XCTAssertEqual(String(describing: interpretedReturnResult), String(describing: realResult))
        XCTAssertEqual(String(describing: type(of: interpretedReturnResult)), String(describing: type(of: realResult)))
    }

    func testAnotherOne1() throws {
        let interpretedReturnResult = try interpretFromString("""
            //
            // start interpreted section
            //
            var arr1 = [0]
            var arr2 = arr1
            arr1.append(5)
            arr2.append(10)
            return arr1[1]
            //
            // end interpreted section
            //
        """) as Any
        func testRealSwift() -> Any {
            //
            // start compiled section
            //
            var arr1 = [0]
            var arr2 = arr1
            arr1.append(5)
            arr2.append(10)
            return arr1[1]
            //
            // end compiled section
            //
        }
        let realResult = testRealSwift()
        XCTAssertEqual(String(describing: interpretedReturnResult), String(describing: realResult))
        XCTAssertEqual(String(describing: type(of: interpretedReturnResult)), String(describing: type(of: realResult)))
    }

    func testAnotherOne2() throws {
        let interpretedReturnResult = try interpretFromString("""
            //
            // start interpreted section
            //
            var arr1 = [0]
            var arr2 = arr1
            arr1.append(5)
            arr2.append(10)
            return arr2[1]
            
            //
            // end interpreted section
            //
        """) as Any
        func testRealSwift() -> Any {
            //
            // start compiled section
            //
            var arr1 = [0]
            var arr2 = arr1
            arr1.append(5)
            arr2.append(10)
            return arr2[1]
            
            //
            // end compiled section
            //
        }
        let realResult = testRealSwift()
        XCTAssertEqual(String(describing: interpretedReturnResult), String(describing: realResult))
        XCTAssertEqual(String(describing: type(of: interpretedReturnResult)), String(describing: type(of: realResult)))
    }

    static var allTests = [
        ("testSomething", testSomething),
        ("testAnotherOne1", testAnotherOne1),
        ("testAnotherOne2", testAnotherOne2),
    ]
}