let input = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

let inputString = input.split(separator: "\n", omittingEmptySubsequences: false)

// part one

func sumOfTop(number: Int) -> Int {
    var sumArray: [Int] = []
    var sum = 0

    for string in inputString {
        if string.isEmpty == false {
            sum += (Int(string) ?? 0)
        } else {
            sumArray.append(sum)
            sum = 0
        }
    }

    let firstN = sumArray.sorted(by: >).prefix(number)
    return firstN.reduce(0, { $0 + $1 })
}

print(sumOfTop(number: 1))

// part two 

print(sumOfTop(number: 3))
