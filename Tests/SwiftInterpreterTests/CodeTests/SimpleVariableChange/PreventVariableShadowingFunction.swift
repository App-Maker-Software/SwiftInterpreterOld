// assert matching_stack_value_y
func x2() -> Int {
    return 0
}
let x = 5
let y = x + x2()

// assert does_not_compile
func x() -> Int {
    return 0
}
let x = 5
let y = x + x()
