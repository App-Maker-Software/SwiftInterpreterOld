import XCTest
import SwiftSyntax
import SwiftASTConstructor
import SwiftInterpreter
#if canImport(SwiftASTScaffolded)
import SwiftASTScaffolded
#endif
import ViewInspector
import SwiftUI

var hasSetup = false
@available(iOS 13.0, macOS 10.15, *)
final class SwiftInterpreterSourceTests: XCTestCase {
    
    let interpreter = SwiftInterpreter(license: .demo)
    
    // helpers
    /// will compile a source file in a swift module and then run some abritary code in that module
    private func simplyTestSomeCode(build sourceFile: String, thenRun testCode: String) throws -> AnyView {
        // main module
        var swiftModule = try interpreter.newSwiftModule(name: "Test")
        
        // source file
        #if canImport(SwiftInterpreterBinary)
        let astData = [UInt8](try SwiftASTConstructor.constructAST(from: sourceFile))
        let swiftFile = try swiftModule.addSwiftFile(name: "test.swift", syntax: astData)
        #else
        let astData = [UInt8](try SwiftASTConstructor.constructAST(from: sourceFile))
        let swiftFile = try swiftModule.addSwiftFile(name: "test.swift", syntax: .init(d: astData, o: 0))
        #endif
        
        // build all sources
        try swiftModule.build()
        
        // parse test code
        let testCodeAstData = [UInt8](try SwiftASTConstructor.constructAST(from: testCode))
        
        // run test code
        #if canImport(SwiftInterpreterBinary)
        let result = try swiftModule.runAsViewBuilder(testCodeAstData)
        #else
        let testCodeScaffold = SwiftASTScaffolded.SourceFileSyntax(d: testCodeAstData, o: 0)
        let result = try swiftModule.runAsViewBuilder(testCodeScaffold)
        #endif
        
        // return result
        return result
    }
    /// will compile 2 source files in a swift module and then run some abritary code in that module
    private func simplyTestSomeCode(build sourceFile: String, and sourceFile2: String, thenRun testCode: String) throws -> AnyView {
        // source files
        let sourceFileScaffold1 = SwiftASTScaffolded.SourceFileSyntax(d: try [UInt8](constructAST(from: sourceFile)), o: 0)
        let sourceFileScaffold2 = SwiftASTScaffolded.SourceFileSyntax(d: try [UInt8](constructAST(from: sourceFile2)), o: 0)
        var swiftModule = try interpreter.newSwiftModule(name: "Test")
        try swiftModule.addSwiftFile(name: "test1.swift", syntax: sourceFileScaffold1)
        try swiftModule.addSwiftFile(name: "test2.swift", syntax: sourceFileScaffold2)
        
        // build all sources
        try swiftModule.build()
        
        // parse test code
        let testCodeAstData = [UInt8](try SwiftASTConstructor.constructAST(from: testCode))
        
        // run test code
        #if canImport(SwiftInterpreterBinary)
        let result = try swiftModule.runAsViewBuilder(testCodeAstData)
        #else
        let testCodeScaffold = SwiftASTScaffolded.SourceFileSyntax(d: testCodeAstData, o: 0)
        let result = try swiftModule.runAsViewBuilder(testCodeScaffold)
        #endif
        
        // return result
        return result
    }
    
    func testText() throws {
        let sourceFile = ""
        let testCode = #"Text("hello")"#
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
    }
    
    func testStructWithText() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
    }
    func testStructWithIfText() throws {
        let sourceFile = """
struct TestIfView: some View {
    let condition: Bool
    var body: some View {
        if condition {
            Text("hello")
        }
    }
}
"""
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestIfView(condition: true)")
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().group().first!.anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let anyView2 = try simplyTestSomeCode(build: sourceFile, thenRun: "TestIfView(condition: false)")
        let inspected2 = try anyView2.inspect()
        let view2 = try inspected2.anyView().find(AMStructView.self)
        XCTAssertNotNil(view2)
        XCTAssertNotNil(try? view2.anyView().group().first?.anyView().emptyView())
    }
    func testStructWithIfAndElseText() throws {
        let sourceFile = """
struct TestIfView: some View {
    let condition: Bool
    var body: some View {
        if condition {
            Text("hello")
        } else {
            Text("world")
        }
    }
}
"""
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestIfView(condition: true)")
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().group().first!.anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let anyView2 = try simplyTestSomeCode(build: sourceFile, thenRun: "TestIfView(condition: false)")
        let inspected2 = try anyView2.inspect()
        let view2 = try inspected2.anyView().find(AMStructView.self)
        XCTAssertNotNil(view2)
        XCTAssertEqual(try view2.anyView().group().first!.anyView().text().string(), "world")
    }
    
    func testStructWith2RootLevelElements() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello")
        Text("hello2")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let structView = try inspected.anyView().find(AMStructView.self).anyView()
        XCTAssertNotNil(structView)
        let subview1 = try structView.group().anyView(0).text()
        let textString = try subview1.string()
        XCTAssertEqual(textString, "hello")
        let subview2 = try structView.group().anyView(1).text()
        let textString2 = try subview2.string()
        XCTAssertEqual(textString2, "hello2")
    }
    
    func testStructWithSimpleStateWithButtonTap() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State private var x = 0
    var body: some View {
        Text("\\(x)")
        Button("button") {
            x = 5
        }
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "5")
    }
    
    func testStructWithSimpleStateAndBindingWithButtonTap() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State var x = 0
    var body: some View {
        TestStateView2(x: $x)
    }
}
struct TestStateView2: some View {
    @Binding var x = 0
    var body: some View {
        Text("\\(x)")
        Button("button") {
            x = 5
        }
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "5")
    }
    
    func testStructWithTwoOfSameTypeEmbeded() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        HStack {
            HStack {
                Text("text in 2 hstacks")
            }
        }
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().hStack().anyView(0).hStack().anyView(0).text()
        let textString = try view.string()
        XCTAssertEqual(textString, "text in 2 hstacks")
    }
    
    func testStructWithSimpleStateWithButtonTapUsingFunc() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State private var x = 0
    func action() {
        x = 5
    }
    var body: some View {
        Text("\\(x)")
        Button("button", action: action)
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)

        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")

        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()

        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "5")
    }
    
    func testStructWithActionOrderMatters() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State private var x = 0
    func action() {
        x = 5
        x = 10
    }
    var body: some View {
        Text("\\(x)")
        Button("button", action: action)
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "10")
    }
    
    func testStructWithActionReferenceOtherStateValue() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State private var x = 0
    @State private var y = 0
    func action() {
        x = y
    }
    var body: some View {
        Text("\\(x)")
        Button("button1", action: {
            y = 3
        })
        Button("button2", action: action)
    }
}
"""// create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        let button2 = try inspectedTestStateView.anyView(2).button()
        try button2.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "3")
    }
    
    
    func testStructWithActionReferenceOtherVariable() throws {
        let sourceFile = """
struct TestStateView: some View {
    let hardCodedValue: Int
    @State private var x = 0
    func action() {
        x = hardCodedValue
    }
    var body: some View {
        Text("\\(x)")
        Button("button", action: action)
    }
}
"""
        // value to test
        let hardCodedValue = 7
        
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView(hardCodedValue: \(hardCodedValue)")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "\(hardCodedValue)")
    }
    
    func testStructWithActionUsingMath() throws {
        let mathTests = [
            (result: 1 + 1, string: "1 + 1"),
            (result: 3 + 2, string: "3 + 2"),
            (result: 1 * 1, string: "1 * 1"),
            (result: 3 * 2, string: "3 * 2"),
            (result: 1 / 1, string: "1 / 1"),
            (result: 4 / 2, string: "4 / 2"),
            (result: 1 - 1, string: "1 - 1"),
            (result: 4 - 2, string: "4 - 2"),
            (result: 1 + 1 - 1, string: "1 + 1 - 1"),
            (result: 4 + 5 - 2, string: "4 + 5 - 2"),
            (result: 1 * 3 - 1, string: "1 * 3 - 1"),
            (result: 4 * 3 - 2, string: "4 * 3 - 2"),
            (result: 1 * (3 - 1), string: "1 * (3 - 1)"),
            (result: 4 * (3 - 2), string: "4 * (3 - 2)"),
            (result: 1 * (3 - 1), string: "1 * (3 - 1)"),
            (result: 4 * (3 - 2), string: "4 * (3 - 2)"),
        ]
        for mathTest in mathTests {
            let sourceFile = """
    struct TestStateView: some View {
        @State private var x = 0
        func action() {
            x = \(mathTest.string)
        }
        var body: some View {
            Text("\\(x)")
            Button("button", action: action)
        }
    }
    """
            // create instance of TestStateView
            let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
            let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
            XCTAssertNotNil(testStateView)
            
            // check that the first text element reads "0" before clicking the button
            let textOfXValue = try inspectedTestStateView.anyView(0).text()
            XCTAssertEqual(try textOfXValue.string(), "0")
            
            // click the button
            let button = try inspectedTestStateView.anyView(1).button()
            try button.tap()
            
            // check that the first text element reads "5" after clicking the button
            let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().group()
            let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
            XCTAssertEqual(try textOfXValue2.string() + " for \(mathTest.string)", "\(mathTest.result) for \(mathTest.string)")
        }
    }
    
    func testStructWithFunction() throws {
        let sourceFile = """
struct TestView: View {
    func x() -> Int {
        return 5
    }
    var body: some View {
        Text("\\(x())")
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    func testStructWithFunctionFromExtension() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("\\(x())")
    }
}
extension TestView {
    func x() -> Int {
        return 5
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    func testStructWithFunctionFromExtensionOutOfOrder() throws {
        let sourceFile = """
extension TestView {
    func x() -> Int {
        return 5
    }
}
struct TestView: View {
    var body: some View {
        Text("\\(x())")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    func testStructWithViewBuilderPropertyFromExtensionOutOfOrder() throws {
        let sourceFile = """
extension TestView {
    func y() -> Int {
        7
    }
    var otherBody: some View {
        Text("\\(x())\\(y())")
    }
}
struct TestView: View {
    func x() -> Int {
        5
    }
    var body: some View {
        otherBody
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "57")
    }
    
    func testStructWithFunctionWithImplicityReturn() throws {
        let sourceFile = """
struct TestView: View {
    func x() -> Int {
        5
    }
    var body: some View {
        Text("\\(x())")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    
    func testStructThatShouldBeInittedBecauseOfMatchingType() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // this should work
    }
}
struct StructWithParamType: View {
    let x: Int
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
        
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testStructThatShouldntBeInittedBecauseOfMismatchingType() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: "3") // should not work
    }
}
struct StructWithParamType: View {
    let x: Int
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            XCTAssertNotNil(testStateView)
            
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {}
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testStructThatShouldBeInittedBecauseOfMatchingTypeUsingOptional() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should work
    }
}
struct StructWithParamType: View {
    let x: Int?
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
            
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    func testStructThatShouldBeInittedBecauseOfMatchingTypeUsingOptional2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: nil) // should work
    }
}
struct StructWithParamType: View {
    let x: Int?
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        XCTAssertNotNil(testStateView)
            
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "nil")
    }
    
    func testStructThatShouldntBeInittedBecauseOfMismatchingTypeUsingOptional() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: "3") // should not work
    }
}
struct StructWithParamType: View {
    let x: Int?
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            XCTAssertNotNil(testStateView)
            
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {}
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testStructThatShouldntBeInittedBecauseOfMismatchingType2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3.3) // should not work
    }
}
struct StructWithParamType: View {
    let x: Int
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            XCTAssertNotNil(testStateView)
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3.3")
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {}
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    
    func testStructThatShouldntBeInittedBecauseOfMismatchingType3() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3.0003) // should not work
    }
}
struct StructWithParamType: View {
    let x: Int
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            XCTAssertNotNil(testStateView)
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3.3")
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {}
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testNonRequiredParameter() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should work
    }
}
struct StructWithParamType: View {
    var x: Int = 1
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testNonRequiredParameter2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType() // should work
    }
}
struct StructWithParamType: View {
    var x: Int = 1
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "1")
    }
    
    func testAccessModifiersFilePrivate() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should work
    }
}
struct StructWithParamType: View {
    fileprivate var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    func testAccessModifiersFilePrivate2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should not work
    }
}
"""
        let sourceFile2 = """
struct StructWithParamType: View {
    fileprivate var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {
                XCTFail()
            }
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testAccessModifiersFilePrivate3() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        ProxyView(x: 3) // should work
    }
}
"""
        let sourceFile2 = """
struct ProxyView: View {
    var x: Int = 3
    var body: some View {
        HasFilePrivate(x: 3)
    }
}
struct HasFilePrivate: View {
    fileprivate var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testAccessModifiersPrivateProperty() throws {
        let sourceFile = """
struct TestView: View {
    private var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        // create instance of TestStateView
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testAccessModifiersPrivateProperty2() throws {
        let sourceFile = """
struct TestView: View {
    private var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        // should fail to init because property has private access
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView(x: 3)")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            do {
                let textOfXValue = try inspectedTestView.text()
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {
                XCTFail()
            }
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testMultipleFileTest() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        TestFromAnotherFile(x: 30) // should work
    }
}
"""
        let sourceFile2 = """
struct TestFromAnotherFile: View {
    var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "30")
    }
    
    func testAccessModifiers() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should not work
    }
}
struct StructWithParamType: View {
    private var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        do {
            let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
            do {
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertNotEqual(try textOfXValue.string(), "3")
            } catch {
                XCTFail()
            }
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    
    func testAccessModifiers2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 3) // should work
    }
}
struct StructWithParamType: View {
    internal var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    func testAccessModifiers3() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType() // should work
    }
}
struct StructWithParamType: View {
    private var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testAccessModifiers4() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType() // should work
    }
}
struct StructWithParamType: View {
    internal var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "3")
    }
    
    func testAccessModifiers5() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 5) // should work
    }
}
struct StructWithParamType: View {
    public var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    func testAccessModifiers6() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 5) // should work
    }
}
struct StructWithParamType: View {
    fileprivate var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    func testAccessModifiers7() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 5) // should work
    }
}
struct StructWithParamType: View {
    var x: Int = 3
    var body: some View {
        Text("\\(x)")
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
        let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
        XCTAssertEqual(try textOfXValue.string(), "5")
    }
    
    
    func testAccessModifiersWithState() throws {
        let sourceFile = """
struct TestStateView: some View {
    @State private var x = 0
    var body: some View {
        TestStateView2(x: $x)
    }
}
struct TestStateView2: some View {
    @Binding var x = 0
    var body: some View {
        Text("\\(x)")
        Button("button") {
            x = 5
        }
    }
}
"""
        let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestStateView()")
        let inspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().find(AMStructView.self).anyView().group()
        XCTAssertNotNil(testStateView)
        
        // check that the first text element reads "0" before clicking the button
        let textOfXValue = try inspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue.string(), "0")
        
        // click the button
        let button = try inspectedTestStateView.anyView(1).button()
        try button.tap()
        
        // check that the first text element reads "5" after clicking the button
        let reinspectedTestStateView = try testStateView.inspect().find(AMStructView.self).anyView().find(AMStructView.self).anyView().group()
        let textOfXValue2 = try reinspectedTestStateView.anyView(0).text()
        XCTAssertEqual(try textOfXValue2.string(), "5")
    }
    
    func testAccessModifiersWithState2() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", true),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
    struct TestView: View {
        var body: some View {
            StructWithParamType(x: 5, y: 7)
        }
    }
    struct StructWithParamType: View {
        var x: Int = 3
        @State \(accessMod) var y = 0
        var body: some View {
            Text("\\(x)_\\(y)")
        }
    }
    """
            if shouldWork {
                let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
                let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertEqual(try textOfXValue.string(), "5_7")
            } else {
                do {
                    let testStateView = try simplyTestSomeCode(build: sourceFile, thenRun: "TestView()")
                    _ = try testStateView.inspect().find(AMStructView.self).anyView()
                    XCTFail("\(accessMod) shouldn't allow outside callers to set, but it did")
                } catch {
                    XCTAssertEqual(true, true)
                }
            }
        }
    }
    
    func testAccessModifiersWithState3() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", false),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
struct TestView: View {
    var body: some View {
        StructWithParamType(x: 5, y: 7)
    }
}
"""
            let sourceFile2 = """
struct StructWithParamType: View {
    var x: Int = 3
    @State \(accessMod) var y = 0
    var body: some View {
        Text("\\(x)_\\(y)")
    }
}
"""
            if shouldWork {
                let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
                let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertEqual(try textOfXValue.string(), "5_7")
            } else {
                do {
                    let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
                    _ = try testStateView.inspect().find(AMStructView.self).anyView()
                    XCTFail("\(accessMod) shouldn't allow outside callers to set, but it did")
                } catch {
                    XCTAssertEqual(true, true)
                }
            }
        }
    }
    
    func testStructAccessModifiers() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", false),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
    struct TestView: View {
        var body: some View {
            StructInAnotherFile() // should work
        }
    }
    """
            let sourceFile2 = """
    \(accessMod) struct StructInAnotherFile: View {
        var body: some View {
            Text("hi")
        }
    }
    """
            if shouldWork {
                let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
                let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
                let textOfXValue = try inspectedTestView.find(AMStructView.self).anyView().text()
                XCTAssertEqual(try textOfXValue.string(), "hi")
            } else {
                do {
                    let testStateView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: "TestView()")
                    _ = try testStateView.inspect().find(AMStructView.self).anyView()
                    XCTFail("\(accessMod) shouldn't allow outside callers to set, but it did")
                } catch {
                    XCTAssertEqual(true, true)
                }
            }
        }
    }
    
    /*
//    func testStructWithFunctionWithIf() throws {
//        let sourceFile = """
//struct TestView: View {
//    func x() -> Int {
//        if true {
//            return 5
//        } else {
//            return 2
//        }
//    }
//    var body: some View {
//        Text("\\(x())")
//    }
//}
//"""
//        // "build" swift file
//        let scaffold = SwiftASTScaffolded.SourceFileSyntax(d: try constructAST(from: sourceFile), o: 0)
//        
//        let stack = SwiftUIStack(specialType: .SwiftModule)
//        scaffold.build(stack, inputSource: .l)
//        
//        // create instance of TestStateView
//        let testStateView = try (try "TestView()".toAST()).sourceFileRenderEverything(stack, isJitMode: false).completeAllAsAnyView()!
//        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
//        XCTAssertNotNil(testStateView)
//        
//        let textOfXValue = try inspectedTestView.text()
//        XCTAssertEqual(try textOfXValue.string(), "5")
//    }
//    
//    func testStructWithComputedProperty() throws {
//        let sourceFile = """
//struct TestView: View {
//    var x: Int {
//        5
//    }
//    var body: some View {
//        Text("\\(x)")
//    }
//}
//"""
//        // "build" swift file
//        let scaffold = SwiftASTScaffolded.SourceFileSyntax(d: try constructAST(from: sourceFile), o: 0)
//        let stack = SwiftUIStack(specialType: .SwiftModule)
//        scaffold.build(stack, inputSource: .l)
//        
//        // create instance of TestStateView
//        let testStateView = try (try "TestView()".toAST()).sourceFileRenderEverything(stack, isJitMode: false).completeAllAsAnyView()!
//        let inspectedTestView = try testStateView.inspect().find(AMStructView.self).anyView()
//        XCTAssertNotNil(testStateView)
//        
//        let textOfXValue = try inspectedTestView.text()
//        XCTAssertEqual(try textOfXValue.string(), "5")
//    }
    */
    
    
    func testDefaultedValueTest1() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int? = 1
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello 1")
    }
    
    func testDefaultedValueTest2() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int? = 1
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView(x: 3)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello 3")
    }
    
    func testDefaultedValueTest3() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int? = nil
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello nil")
    }
    
    func testDefaultedValueTest4() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int? = 3
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView(x: nil)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello nil")
    }
    
    func testImplicitDefault() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int?
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello nil")
    }
    
    func testNonDefaultable() throws {
        let sourceFile = """
struct TestView: View {
    var x: Int
    var body: some View {
        Text("hello \\(x)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        do {
            _ = try inspected.anyView().find(AMStructView.self).anyView().text()
            XCTFail()
        } catch {
            XCTAssertEqual(true, true)
        }
    }
    
    func testSlider() throws {
        let sourceFile = """
struct TestView: View {
    @State var x: Double = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 0.52)
    }
    
    func testTypeInferenceForStructParam1() throws {
        let sourceFile = """
struct TestView: View {
    @State var x: Double = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView(x: 0.4)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 0.4)
    }
    func testTypeInferenceForStructParam2() throws {
        let sourceFile = """
struct TestView: View {
    @State var x = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView(x: 0.4)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 0.4)
    }
    func testTypeInferenceForStructParam3() throws {
        let sourceFile = """
struct TestView: View {
    @State var x: Double = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView(x: 1)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 1)
    }
    func testTypeInferenceForStructParam4() throws {
        let sourceFile = """
struct TestView: View {
    @State var x = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView(x: 1)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 1)
    }
    func testTypeInferenceForStructParam5() throws {
        let sourceFile = """
struct TestView: View {
    @State var x: Double = 0.52
    var body: some View {
        Slider(value: $x)
    }
}
"""
        let testCode = "TestView(x: 0.4)"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().slider()
        let textString = try view.value()
        XCTAssertEqual(textString, 0.4)
    }
    
    func testColorStateVariant1() throws {
        let sourceFile = """
struct TestView: View {
    @State var c: Color = Color(.red)
    var body: some View {
        c
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().color()
        let textString = try view.value()
        XCTAssertEqual(textString, Color(.red))
    }
    
    func testColorStateVariant2() throws {
        let sourceFile = """
struct TestView: View {
    @State var c: Color = Color.red
    var body: some View {
        c
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().color()
        let textString = try view.value()
        XCTAssertEqual(textString, .red)
    }
    
    func testColorStateVariant3() throws {
        let sourceFile = """
struct TestView: View {
    @State var c = Color.red
    var body: some View {
        c
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().color()
        let textString = try view.value()
        XCTAssertEqual(textString, .red)
    }
    
    func testColorStateVariant4() throws {
        let sourceFile = """
struct TestView: View {
    @State var c = Color(.red)
    var body: some View {
        c
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().color()
        let textString = try view.value()
        XCTAssertEqual(textString, Color(.red))
    }
    
    func testAngleStateVariant1() throws {
        let sourceFile = """
struct TestView: View {
    @State var a = Angle.zero
    var body: some View {
        Text("\\(a)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "\(Angle.zero)")
    }
    
    func testAngleStateVariant2() throws {
        let sourceFile = """
struct TestView: View {
    @State var a: Angle = Angle.zero
    var body: some View {
        Text("\\(a)")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "\(Angle.zero)")
    }
    
    func testAccessModifiersOnGlobalVariables() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", false),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("\\(x)")
    }
}
"""
            let sourceFile2 = """
\(accessMod) let x = 5
"""
            let testCode = "TestView()"
            let anyView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: testCode)
            let inspected = try anyView.inspect()
            if shouldWork {
                let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                let textString = try view.string()
                XCTAssertEqual(textString, "5")
            } else {
                do {
                    let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                    let textString = try view.string()
                    XCTAssertNotEqual(textString, "5")
                } catch {
                    XCTAssertTrue(true)
                }
            }
        }
    }
    
    func testAccessModifiersOnGlobalFunctions() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", false),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("\\(x())")
    }
}
"""
            let sourceFile2 = """
\(accessMod) func x() -> String {
    return "hello"
}
"""
            let testCode = "TestView()"
            let anyView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: testCode)
            let inspected = try anyView.inspect()
            if shouldWork {
                let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                let textString = try view.string()
                XCTAssertEqual(textString, "hello")
            } else {
                do {
                    let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                    let textString = try view.string()
                    XCTAssertNotEqual(textString, "hello")
                } catch {
                    XCTAssertTrue(true)
                }
            }
        }
    }
    
    func testAccessModifiersOnExtensionsInAnotherFile() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", false),
            ("private", false), // shouldn't work hence false
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("\\(x())")
    }
}
"""
            let sourceFile2 = """
\(accessMod) extension TestView {
    func x() -> String {
        return "hello"
    }
}
"""
            let testCode = "TestView()"
            let anyView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: testCode)
            let inspected = try anyView.inspect()
            if shouldWork {
                let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                let textString = try view.string()
                XCTAssertEqual(textString, "hello")
            } else {
                do {
                    let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                    let textString = try view.string()
                    XCTAssertNotEqual(textString, "hello")
                } catch {
                    XCTAssertTrue(true)
                }
            }
        }
    }
    
    func testAccessModifiersOnExtensionsInAnotherFile2() throws {
        let modifiers = [
            ("public", true),
            ("internal", true),
            ("fileprivate", true),  // because it's called from TestView2 which is in the same file as the extension, it should work
            ("private", true), // because it's called from TestView2 which is in the same file as the extension, it should work
            ("", true)
        ]
        for (accessMod, shouldWork) in modifiers {
            let sourceFile = """
struct TestView: View {
    var body: some View {
        TestView2()
    }
}
"""
            let sourceFile2 = """
\(accessMod) extension TestView2 {
    func x() -> String {
        return "hello"
    }
}
struct TestView2: View {
    var body: some View {
        Text("\\(x())")
    }
}
"""
            let testCode = "TestView()"
            let anyView = try simplyTestSomeCode(build: sourceFile, and: sourceFile2, thenRun: testCode)
            let inspected = try anyView.inspect()
            if shouldWork {
                let view = try inspected.anyView().find(AMStructView.self).anyView().find(AMStructView.self).anyView().text()
                let textString = try view.string()
                XCTAssertEqual(textString, "hello")
            } else {
                do {
                    let view = try inspected.anyView().find(AMStructView.self).anyView().text()
                    let textString = try view.string()
                    XCTAssertNotEqual(textString, "hello")
                } catch {
                    XCTAssertTrue(true)
                }
            }
        }
    }
    
    
    func testAddingText() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("a") + Text("b")
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "ab")
    }
    
    func testAddingTextWithBold() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("a") + Text("b").bold()
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "ab")
    }
    
    func testDefaultArgumentCallingFunction() throws {
        let sourceFile = """
struct TestView: View {
    @State private var x: Int = getInt()
    var body: some View {
        Text("\\(x)")
    }
}
func getInt() -> Int {
    return 5
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "5")
    }
    
    func testGlobalSwiftUIObject() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        someText
    }
}
let someText = Text("hello")
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
    }
    
    func testGlobalSwiftUIObjectWithModifier() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        someText
    }
}
let someText = Text("hello").padding()
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
    }
    
    func testGlobalSwiftUIObjectWithModifierAfterAccess() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        someText.padding()
    }
}
let someText = Text("hello")
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
    }
    
    func testModifier() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello").foregroundColor(Color.red)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let color = try view.attributes().foregroundColor()
        XCTAssertEqual(color, .red)
    }
    
    func testModifier2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello").foregroundColor(.red)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let color = try view.attributes().foregroundColor()
        XCTAssertEqual(color, .red)
    }
    
    func testModifier3() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello").font(Font.footnote)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let color = try view.attributes().font()
        XCTAssertEqual(color, .footnote)
    }
    
    func testModifier4() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Text("hello").font(.footnote)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let view = try inspected.anyView().find(AMStructView.self).anyView().text()
        let textString = try view.string()
        XCTAssertEqual(textString, "hello")
        let color = try view.attributes().font()
        XCTAssertEqual(color, .footnote)
    }
    
    func testDivider() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Divider()
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().divider()
        XCTAssertEqual(true, true)
    }
    
    func testSpacer() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Spacer()
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().spacer()
        XCTAssertEqual(true, true)
    }
    
    func testSpacer2() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Spacer(minLength: 30)
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        let spacer = try inspected.anyView().find(AMStructView.self).anyView().spacer()
        XCTAssertEqual(try spacer.minLength(), 30)
    }
    
    func testRect() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Rectangle()
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().shape()
        XCTAssertEqual(true, true)
    }
    
    
    func testRectInVStack() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        VStack {
            Rectangle()
        }
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().vStack().anyView(0).shape()
        XCTAssertEqual(true, true)
    }
    
    func testShapesInVStack() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        VStack {
            Rectangle()
            Circle()
        }
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().vStack().anyView(0).group().anyView(0).shape()
        _ = try inspected.anyView().find(AMStructView.self).anyView().vStack().anyView(0).group().anyView(1).shape()
        XCTAssertEqual(true, true)
    }
    
    func testShape() throws {
        let sourceFile = """
struct TestView: View {
    var body: some View {
        Rectangle().stroke(style: StrokeStyle(lineWidth: 2))
    }
}
"""
        let testCode = "TestView()"
        let anyView = try simplyTestSomeCode(build: sourceFile, thenRun: testCode)
        let inspected = try anyView.inspect()
        _ = try inspected.anyView().find(AMStructView.self).anyView().shape()
//        let rect = try inspected.anyView().find(AMStructView.self).anyView().shape()
        // we can't actually extract the stroke style because the modified base shape must get wrapped into another AnyShape making it impossible to see the stroke modifier
//        let strokeStyle = try rect.strokeStyle()
//        XCTAssertEqual(strokeStyle, StrokeStyle(lineWidth: 2))
        XCTAssertEqual(true, true)
    }

    static var allTests = [()]
}
