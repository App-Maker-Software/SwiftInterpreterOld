// assert matching_stack_value_result
func genericTest<T: FloatingPoint>(_ val: T) -> T {
    return val * val
}
let result = genericTest(3)
