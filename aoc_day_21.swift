let input = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

enum Operation {
    case plus
    case minus
    case multiplication
    case division

    init(_ rawValue: String) {
        switch rawValue {
        case "+": self = .plus
        case "-": self = .minus
        case "/": self = .division
        case "*": self = .multiplication
        default: self = .plus
        }
    }
}

struct Expression {
    let first: String
    let operation: Operation
    let second: String
}

var dict: [String: Expression] = [:]
var result: [String: Int] = [:]

for string in inputStrings {
    let split = string.split(separator: ": ").map({ String($0) })
    let key = split[0]
    if let value = Int(split[1]) {
        result[key] = value
    } else {
        let exp = split[1].split(separator: " ").map({ String($0) })
        dict[key] = Expression(first: exp[0], operation: Operation(exp[1]), second: exp[2])
    }
}

while dict.isEmpty == false {
    for element in dict {

        if let first = result[element.value.first],
           let second = result[element.value.second] {

            let newResult: Int
            switch element.value.operation {
            case .plus: newResult = first + second
            case .minus: newResult = first - second
            case .multiplication: newResult = first * second
            case .division: newResult = first / second
            }

            result[element.key] = newResult
            dict[element.key] = nil
        }
    }
}

print(result["root"])
