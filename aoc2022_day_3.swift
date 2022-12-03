let input = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

// helpers

func weight(symbol: Character) -> Int {
    let ascii = Int(symbol.asciiValue ?? 0)
    if symbol.isLowercase {
        return ascii - 96
    } else {
        return ascii - 38
    }
}

// part one

let contentSets: [(firstPart: Set, secondPart: Set)] = inputStrings.map { string in
    let firstSet = Set(string.prefix(string.count / 2))
    let secondSet = Set(string.suffix(string.count / 2))
    return (firstSet, secondSet)
}

let intersectionsPartOne: [Character] = contentSets.compactMap { $0.firstPart.intersection($0.secondPart).first }
let sumPartOne = intersectionsPartOne.reduce(0, { $0 + weight(symbol: $1) })
print(sumPartOne)

// part two

var intersectionsPartTwo: [Character] = []

var inputStringsPartTwo = inputStrings
while inputStringsPartTwo.isEmpty == false {
    let set0 = Set(inputStringsPartTwo[0])
    let set1 = Set(inputStringsPartTwo[1])
    let set2 = Set(inputStringsPartTwo[2])

    let intersection = set0.intersection(set1.intersection(set2))
    if let symbol = intersection.first {
        intersectionsPartTwo.append(symbol)
    }
    inputStringsPartTwo.removeFirst(3)
}

let sumPartTwo = intersectionsPartTwo.reduce(0, { $0 + weight(symbol: $1) })
print(sumPartTwo)

