// assert matching_stack_value_x
var x = 4
x = x + 1
func shouldntAdd() {
    var x = x
    x = x + 5
}
shouldntAdd()

// assert matching_stack_value_x
var x = 4
x = x + 1
func shouldAdd() {
    x = x + 5
}
shouldAdd()

// assert does_not_compile
let x = 4
func shouldFailDoingAdd() {
    x = x + 5
}
shouldFailDoingAdd()
