// assert matching_return_value
var arr1 = [0]
var arr2 = arr1
arr1.append(5)
arr2.append(10)
return arr1[1]

// assert matching_return_value
var arr1 = [0]
var arr2 = arr1
arr1.append(5)
arr2.append(10)
return arr2[1]
