import string
# a collection of python functions for gyb files to use to quickly test Swift Interpreter against real Swift
testNames = []

def _addSpaces(s, numSpaces):
    s = string.split(s, '\n')
    s = [(numSpaces * ' ') + line for line in s]
    s = string.join(s, '\n')
    return s
    
def _wrapInTestFunc(testName, body):
    _addTestName("test"+testName)
    return _addSpaces("func test" + testName + "() throws {\n" + _addSpaces(body, 4) + "\n}", 4)

def _addTestName(name):
    testNames.append("(\""+name+"\", " + name + "),")
    
def _createSection(title, swiftSource):
    if title == "compiled":
        return "\n"+_addSpaces("//\n// start "+ title + " section\n//\n"+ swiftSource + "\n//\n// end " + title + " section\n//", 4) + "\n"
    else:
        return "\"\"\"\n"+_addSpaces("//\n// start "+ title + " section\n//\n"+ swiftSource + "\n//\n// end " + title + " section\n//", 4) + "\n\"\"\""
    
def assertDoesNotCompile(testName, swiftSource):
    return _wrapInTestFunc(testName, "do { let returnedValue = try interpretFromString("+_createSection("interpreted", swiftSource)+") as Any; XCTFail(\"Interpreted Swift \\\"compiled\\\" that should not have! It recieved a return value of \(String(describing: returnedValue))\")} catch {XCTAssertTrue(true)}")

def assertMatchingReturnValue(testName, swiftSource):
    interpretTest = "let interpretedReturnResult = try interpretFromString("+_createSection("interpreted", swiftSource)+") as Any"
    realSwiftTest = "func testRealSwift() -> Any {" + _createSection("compiled", swiftSource) + "}"
    swiftAssert = "let realResult = testRealSwift()\nXCTAssertEqual(String(describing: interpretedReturnResult), String(describing: realResult))\nXCTAssertEqual(String(describing: type(of: interpretedReturnResult)), String(describing: type(of: realResult)))"
    return _wrapInTestFunc(testName, interpretTest + "\n" + realSwiftTest + "\n" + swiftAssert)

def assertGlobalMatchingStackValue(testName, stackKey, swiftSource):
    setup = "let stack = Stack.createNewBase()\nvar expectedValueOnStack: Any? = nil"
    interpretTest = "try interpretFromString("+_createSection("interpreted", swiftSource)+", using: stack)"
    realSwiftTest = "// "+testName+" requires a global namespace\n" + swiftSource
    swiftAssert = "expectedValueOnStack = " + stackKey + "\nlet interpretedResult = try stack.get(\""+ stackKey +"\") as Any\nlet realResult = try expectedValueOnStack.unwrap()\n\nXCTAssertEqual(String(describing: interpretedResult), String(describing: realResult))\nXCTAssertEqual(String(describing: type(of: interpretedResult)), String(describing: type(of: realResult)))"
    return (_wrapInTestFunc(testName, setup + "\n" + interpretTest + "\n" + swiftAssert), realSwiftTest)

def assertMatchingStackValue(testName, stackKey, swiftSource):
    setup = "let stack = Stack.createNewBase()\nvar expectedValueOnStack: Any? = nil"
    interpretTest = "try interpretFromString("+_createSection("interpreted", swiftSource)+", using: stack)"
    realSwiftTest = "func testRealSwift() {" + _createSection("compiled", swiftSource) + "    expectedValueOnStack = " + stackKey + "\n" + "}"
    swiftAssert = "testRealSwift()\nlet interpretedResult = try stack.get(\""+ stackKey +"\") as Any\nlet realResult = try expectedValueOnStack.unwrap()\n\nXCTAssertEqual(String(describing: interpretedResult), String(describing: realResult))\nXCTAssertEqual(String(describing: type(of: interpretedResult)), String(describing: type(of: realResult)))"
    return _wrapInTestFunc(testName, setup + "\n" + interpretTest + "\n" + realSwiftTest + "\n" + swiftAssert)

def allTests():
    return "static var allTests = [\n        " + "\n        ".join(testNames) + "\n    ]"
