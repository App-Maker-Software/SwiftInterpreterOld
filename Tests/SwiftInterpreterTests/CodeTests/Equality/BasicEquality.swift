// assert matching_return_value
return 5 == 5

// assert matching_return_value
return 5 != 5

// assert matching_return_value
return true == true

// assert matching_return_value
return true != false

// assert matching_return_value
return false == false

// assert matching_return_value
return false != false

// assert matching_return_value
return false != false

// assert matching_return_value
let x = 5.5
let y = 5.5
return x != y

// assert matching_return_value
let x = 5.5
let y = 5.5
return x == y

// assert does_not_compile
let x = 5.5
let y = 5
return x == y

// assert does_not_compile
let x = 5
let y = 5.5
return x == y

// assert does_not_compile
let x = 5
let y = 5.5
return x != y

// assert does_not_compile
return 5 == 5.5

// assert matching_return_value
return 5 != 5.5

// assert does_not_compile
return 5.5 == 5

// assert matching_return_value
return 5.0 != 5

// assert matching_return_value
return "hi" == "hi"

// assert matching_return_value
return "hi" != "hi"

// assert matching_return_value
return "hi" == "bye"

// assert matching_return_value
return "hi" != "bye"

// assert does_not_compile
func test() {
    return 5
}
let x = test()
