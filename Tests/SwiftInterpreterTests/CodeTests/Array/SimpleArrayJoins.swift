// assert matching_return_value
let arr = [1,2]
let arr2 = arr + [3]
return arr2[2]

// assert matching_return_value
let arr = [1,2]
let arr2 = arr + [3,4]
return arr2[3]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + arr2
return arr3[3]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0], arr2[1]]
return arr3[3]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0], arr2[1]]
return arr3[2]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0], arr2[1]]
return arr3[1]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0], arr2[1]]
return arr3[0]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0], arr2[1] + 5]
return arr3[3]

// assert matching_return_value
let arr = [1,2]
let arr2 = [3,4]
let arr3 = arr + [arr2[0] + arr[1], arr2[1] - 5]
return arr3[3]
