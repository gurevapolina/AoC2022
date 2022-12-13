import Foundation

enum Message: ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral, Comparable {
    case value(Int)
    indirect case list([Message])

    init(integerLiteral: Int) {
        self = .value(integerLiteral)
    }

    init(arrayLiteral: Self...) {
        self = .list(arrayLiteral)
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.value(let l), .value(let r)): return l < r
        case (.value(_), .list(_)): return .list([lhs]) < rhs
        case (.list(_), .value(_)): return lhs < .list([rhs])
        case (.list(let l), .list(let r)):
            for (le, re) in zip(l, r) {
                if le < re { return true }
                if le > re { return false }
            }
            return l.count < r.count
        }
    }
}

let messages: [Message] = [
    [1,1,3,1,1],
    [1,1,5,1,1],

    [[1],[2,3,4]],
    [[1],4],

    [9],
    [[8,7,6]],

    [[4,4],4,4],
    [[4,4],4,4,4],

    [7,7,7,7],
    [7,7,7],

    [],
    [3],

    [[[]]],
    [[]],

    [1,[2,[3,[4,[5,6,7]]]],8,9],
    [1,[2,[3,[4,[5,6,0]]]],8,9],
]

// part one

var sum = 0
var index = 0
while index < messages.count {
    let m1 = messages[index]
    let m2 = messages[index + 1]

    if m1 < m2 {
        sum += (index / 2) + 1
    }
    index += 2
}
print(sum)

// part two

let div2: Message = [[2]]
let div6: Message = [[6]]

var messagesPartTwo = messages + [div2, div6]
messagesPartTwo.sort()

let indexOf2 = messagesPartTwo.firstIndex(of: div2)! + 1
let indexOf6 = messagesPartTwo.firstIndex(of: div6)! + 1
print(indexOf2 * indexOf6)
