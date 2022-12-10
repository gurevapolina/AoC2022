let input = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

// helpers

enum Command {
    case lef(Int)
    case righ(Int)
    case up(Int)
    case down(Int)
    
    init?(_ string: String) {
        let split = string.split(separator: " ")
        let value = Int(String(split[1])) ?? 0
        switch split[0] {
        case "R":
            self = .righ(value)
        case "L":
            self = .lef(value)
        case "U":
            self = .up(value)
        case "D":
            self = .down(value)
        default:
            return nil
        }
    }
}

func executeCommand(_ command: Command) {
    switch command {
    case let .righ(value), let .lef(value), let .up(value), let .down(value):
        for _ in 0..<value {
            executeOne(command)
        }
    }
}

func executeOne(_ command: Command) {
    switch command {
    case .righ:
        tails[0] = (tails[0].0 + 1, tails[0].1)
    case .lef:
        tails[0] = (tails[0].0 - 1, tails[0].1)
    case .up:
        tails[0] = (tails[0].0, tails[0].1 + 1)
    case .down:
        tails[0] = (tails[0].0, tails[0].1 - 1)
    }
    
    for index in 1..<tails.count {
        adjustTailPartTwo(index: index)
    }
    tailPositions.insert([tails[tails.count - 1].0, tails[tails.count - 1].1])
}

func newPoint(a: Int, b: Int) -> Int {
    return a + b - ((a + b) / 2)
}

func adjustTailPartTwo(index: Int) {
    if abs(tails[index].1 - tails[index - 1].1) <= 1 && abs(tails[index].0 - tails[index - 1].0) <= 1 {
        return
    }
    
    if tails[index - 1].0 == tails[index].0 &&
        abs(tails[index].1 - tails[index - 1].1) == 2 {
        
        tails[index] = (tails[index].0, newPoint(a: tails[index].1, b: tails[index - 1].1))
        
    } else if tails[index - 1].1 == tails[index].1 &&
                abs(tails[index].0 - tails[index - 1].0) == 2 {
        
        tails[index] = (newPoint(a: tails[index].0, b: tails[index - 1].0), tails[index].1)
        
    } else if abs(tails[index].0 - tails[index - 1].0) > 1 &&
                abs(tails[index].1 - tails[index - 1].1) == 1 {
        if tails[index].0 < tails[index - 1].0 {
            tails[index] = (tails[index].0 + 1, tails[index - 1].1)
        }
        if tails[index - 1].0 < tails[index].0 {
            tails[index] = (tails[index - 1].0 + 1, tails[index - 1].1)
        }
    } else if abs(tails[index].1 - tails[index - 1].1) > 1 &&
                abs(tails[index].0 - tails[index - 1].0) == 1 {
        if tails[index].1 < tails[index - 1].1 {
            tails[index] = (tails[index - 1].0, tails[index].1 + 1)
        }
        if tails[index - 1].1 < tails[index].1 {
            tails[index] = (tails[index - 1].0, tails[index - 1].1 + 1)
        }
    } else if abs(tails[index].0 - tails[index - 1].0) == 2 &&
                abs(tails[index].1 - tails[index - 1].1) == 2 {
        if tails[index].0 < tails[index - 1].0 && tails[index].1 < tails[index - 1].1 {
            tails[index] = (tails[index].0 + 1 , tails[index].1 + 1)
        }
        if tails[index].0 < tails[index - 1].0 && tails[index].1 > tails[index - 1].1 {
            tails[index] = (tails[index].0 + 1 , tails[index].1 - 1)
        }
        if tails[index].0 > tails[index - 1].0 && tails[index].1 > tails[index - 1].1 {
            tails[index] = (tails[index].0 - 1 , tails[index].1 - 1)
        }
        if tails[index].0 > tails[index - 1].0 && tails[index].1 < tails[index - 1].1 {
            tails[index] = (tails[index].0 - 1 , tails[index].1 + 1)
        }
        
    }
}

var commands = inputStrings.compactMap({ Command($0) })

// part one

var count = 2
var tailPositions = Set<[Int]>()
var tails: [(Int, Int)] = Array(repeating: (0, 0), count: count)

commands.forEach({ executeCommand($0) })
print(tailPositions.count)

// part two

count = 10
tailPositions = Set<[Int]>()
tails = Array(repeating: (0, 0), count: count)

commands.forEach({ executeCommand($0) })
print(tailPositions.count)
