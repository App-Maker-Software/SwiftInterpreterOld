// assert matching_return_value
let x: Double = 5.5
let y: Double = 5.7
return x + y

// assert matching_return_value
let x: Int = 3
let y: Int = 5
return x + y

// assert matching_return_value
let x: Double = 3
let y: Double = 5
return x + y

// assert does_not_compile
let x: Int = 3
let y: Double = 5
return x + y

// assert does_not_compile
let x: Int = 3.5
return x

// assert does_not_compile
let x: UInt = -1
return x

// assert does_not_compile
let x = 5
let y = 5.5
return x + y
