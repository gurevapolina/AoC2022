let input = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

// helpers

class Sensor {
    var at: (Int, Int)
    var beacon: (Int, Int)

    var length: Int {
        abs(at.0 - beacon.0) + abs(at.1 - beacon.1)
    }

    init(at: (Int, Int), beacon: (Int, Int)) {
        self.at = at
        self.beacon = beacon
    }

    func range(y: Int) -> ClosedRange<Int>? {
        let offset = abs(at.0 - y)
        guard offset <= length else { return nil }

        let count = length - offset

        return ClosedRange(uncheckedBounds: (at.1 - count, at.1 + count))
    }
}

let sensors = inputStrings.map({ str in
    var values = str.replacingOccurrences(of: "Sensor at x=", with: "")
        .replacingOccurrences(of: ", y=", with: " ")
        .replacingOccurrences(of: ": closest beacon is at x=", with: " ")
        .split(separator: " ")
        .compactMap({ Int(String($0)) })
    return Sensor(at: (values[1], values[0]), beacon: (values[3], values[2]))
})

func mergeRanges(first: ClosedRange<Int>, second: ClosedRange<Int>) -> ClosedRange<Int>? {
    if first.overlaps(second) == false {
        return nil
    }
    let lower = min(first.lowerBound, second.lowerBound)
    let upper = max(first.upperBound, second.upperBound)
    return ClosedRange(uncheckedBounds: (lower, upper))
}

func mergeRanges(ranges: [ClosedRange<Int>]) -> ClosedRange<Int>? {
    var ranges = ranges
    while ranges.count > 1 {
        let first = ranges.removeFirst()
        let second = ranges.removeFirst()
        if let new = mergeRanges(first: first, second: second) {
            ranges.insert(new, at: 0)
        } else {
            return nil
        }
    }
    return ranges[0]
}

func pointsAmount(y: Int) -> Int {
    var ranges = sensors.compactMap({ $0.range(y: y) }).sorted(by: { $0.lowerBound < $1.lowerBound })
    return mergeRanges(ranges: ranges)?.count ?? 0 - 1
}

// part one

let y = 10
print(pointsAmount(y: y))
