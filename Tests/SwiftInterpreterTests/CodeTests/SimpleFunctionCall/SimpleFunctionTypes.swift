// assert matching_return_value
func test() -> Void {
    return
}
return test()

// assert matching_return_value
func test() -> Void {}
return test()

// assert matching_return_value
func test() -> () {
    return
}
return test()

// assert matching_return_value
func test() -> () {}
return test()

// assert matching_return_value
func test() {
    return
}
return test()

// assert matching_return_value
func test() {}
return test()

