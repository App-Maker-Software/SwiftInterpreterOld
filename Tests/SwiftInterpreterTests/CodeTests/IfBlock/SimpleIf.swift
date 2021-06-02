// assert matching_stack_value_x
var x = 0
if true {
    x = 2
}

// assert matching_stack_value_x
let x = 0
if false {
}

// assert matching_stack_value_x
let x = 0
if true {
}

// assert matching_stack_value_x
var x = 0
if true {
    x = 2
} else {
}

// assert matching_stack_value_x
var x = 0
if false {
} else {
    x = 3
}

// assert matching_stack_value_x
var x = 0
var y = 2
y = y + 1
if y != 2 {
    x = 2
}
