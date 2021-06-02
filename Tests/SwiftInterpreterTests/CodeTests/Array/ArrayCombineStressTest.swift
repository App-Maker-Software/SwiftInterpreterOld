// assert matching_return_value
func makeArray() -> [Int] {
    return [1]
}
var test = makeArray()
test.append(contentsOf: makeArray())
test.append(contentsOf: makeArray())
test = test + makeArray()
let x = test[2] + test[3]
let y = test[0] + test[1]
return x + y
