let input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })
let inputPairs = inputStrings.compactMap({ rangePairFromString($0) })

// helpers

typealias RangePair = (first: ClosedRange<Int>, second: ClosedRange<Int>)

func rangeFromString(_ string: String) -> ClosedRange<Int>? {
    let pair = string.split(separator: "-").compactMap({ String($0) })
    guard let lower = Int(pair[0]),
          let upper = Int(pair[1]) else { return nil }
    return ClosedRange(uncheckedBounds: (lower, upper))
}

func rangePairFromString(_ string: String) -> RangePair? {
    let pair = string.split(separator: ",").compactMap({ String($0) })
    guard let first = rangeFromString(pair[0]),
          let second = rangeFromString(pair[1]) else { return nil }
    return (first, second)
}

func isFullyCovered(rangePair: RangePair) -> Bool {
    let newLower = min(rangePair.first.lowerBound, rangePair.second.lowerBound)
    let newUpper = max(rangePair.first.upperBound, rangePair.second.upperBound)
    let newRange = ClosedRange(uncheckedBounds: (newLower, newUpper))

    return newRange.count == rangePair.first.count || newRange.count == rangePair.second.count
}

func isOverlap(rangePair: RangePair) -> Bool {
    return rangePair.first.overlaps(rangePair.second)
}

// part one

let numberOfRangesPartOne = inputPairs.reduce(0, { $0 + (isFullyCovered(rangePair: $1) ? 1 : 0) } )
print(numberOfRangesPartOne)

// part two

let numberOfRangesPartTwp = inputPairs.reduce(0, { $0 + (isOverlap(rangePair: $1) ? 1 : 0) } )
print(numberOfRangesPartTwp)
