// assert matching_return_value
func test() -> Int {
    let x = 5
    return x
}
return test()

// assert matching_return_value
func getY() -> Int {
    let y = 5
    return y
}
func test() -> Int {
    let x = getY()
    return x
}
return test()

// assert matching_return_value
let y = 5
func getY() -> Int {
    return y
}
func test() -> Int {
    let x = getY()
    return x
}
return test()

// assert matching_return_value
let y = 5
func getY() -> Int {
    func getZ() -> Int {
        let z = 5
        return z
    }
    return y + getZ()
}
func test() -> Int {
    let x = getY()
    return x
}
return test()

// assert does_not_compile
let y = 5
func getY() -> Int {
    func getZ() -> Int {
        let z = 5
        return z
    }
    return y + getZ()
}
func test() -> Int {
    let x = getY() + getZ()
    return x
}
return test()

// assert does_not_compile
let y = 5
func getY() -> Int {
    func getZ() -> Int {
        let z = 5
        return z
    }
    return y + getZ()
}
return getZ()
