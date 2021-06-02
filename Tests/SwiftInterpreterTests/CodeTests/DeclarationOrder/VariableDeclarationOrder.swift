// assert matching_stack_value_result
let x = 4
let result = x + 5

// assert does_not_compile
let result = x + 5
let x = 4

// assert matching_return_value
var i = 0
while i < 3 {
    i = i + 1
    var j = 0
    while j < 3 {
        j = j + 1
    }
}
return i