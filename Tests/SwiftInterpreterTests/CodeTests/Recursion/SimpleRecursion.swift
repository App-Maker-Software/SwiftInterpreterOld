// assert matching_stack_value_result
func factorial(of num: Int) -> Int {
    if num == 1 {
        return 1
    } else {
        let val = num - 1
        return num * factorial(of:val)
    }
}
//let x = 12
let x = 3
let result = factorial(of: x)

// assert matching_stack_value_result
func fibonacci(inNum i: Int) -> Int {
    if i <= 2 {
        return 1
    } else {
        return fibonacci(inNum: i - 1) + fibonacci(inNum: i - 2)
    }
}
//let x = 12
let x = 3
let result = fibonacci(inNum: x)

// assert matching_stack_value_result
//func digits(_ number: Int) -> [Int] {
//    if number >= 10 {
//        let firstDigits = digits(number / 10)
//        let lastDigit = number % 10
//        return firstDigits + [lastDigit]
//    } else {
//        return [number]
//    }
//}
//
//let x = 192831
//let result = digits(x)
// todo: after array support
let result = true

// assert matching_stack_value_result
func pow(_ x: Int, _ y: Int) -> Int {
    if y == 0 {
        return 1
    } else {
        if y == 1 {
            return x
        } else {
            // compute x^(y/2)
            let xy2 = pow(x, y / 2)
            // if y is even
            let modResult = y % 2
            if modResult == 0 {
                // x^y is x^(y/2) squared
                return xy2 * xy2
            } else {
                // x^y is x^(y/2) squared times x
                let val = xy2 * xy2
                return val * x
            }
        }
    }
}
let result = pow(3,2)

// assert matching_stack_value_result
func gcd(_ a: Int, _ b: Int) -> Int {
    if b == 0 {
        return a
    } else {
        if a > b {
            return gcd(a-b, b)
        } else {
            return gcd(a, b-a)
        }
    }
}
let result = gcd(30, 75)
