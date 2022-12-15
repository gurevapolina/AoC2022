let input = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

// helpers

var width = 500
var height = 0

let lines = inputStrings.map({
    $0.split(separator: " -> ").map({ String($0) }).map { str in
        let split = str.split(separator: ",").map({ String($0) }).compactMap({ Int($0) })
        if split[0] + 1 > width {
            width = split[0] + 1
        }
        if split[1] + 1 > height {
            height = split[1] + 1
        }
        return (split[1], split[0])
    }
})

let entry = (0, 500)
var matrix = Array(repeating: Array<String>(repeating: ".", count: width + height), count: height)

matrix[entry.0][entry.1] = "o"

for line in lines {
    for pair in 1..<line.count {
        let fromX = min(line[pair].1, line[pair - 1].1)
        let toX = max(line[pair].1, line[pair - 1].1)
        let fromY = min(line[pair].0, line[pair - 1].0)
        let toY = max(line[pair].0, line[pair - 1].0)

        for i in fromY...toY {
            for j in fromX...toX {
                matrix[i][j] = "#"
            }
        }
    }
}

func checkMove(_ move: (Int, Int)) -> (Int, Int)? {
    let new = (currentSnow.0 + move.0, currentSnow.1 + move.1)
    if new.0 == matrix.count {
        isFinished = true
    }
    if new.0 < matrix.count && new.1 < (matrix.first?.count ?? width)
        && matrix[new.0][new.1] != "#" && matrix[new.0][new.1] != "o" {
        return new
    }
    return nil
}

func update(_ new: (Int, Int)) {
    matrix[currentSnow.0][currentSnow.1] = "."
    currentSnow = new
    matrix[new.0][new.1] = "o"
}

var moveDown = (1, 0)
var moveDownLeft = (1, -1)
var moveDownRight = (1, 1)

// part one

let cleanMatrix = matrix

var currentSnow = entry
var snowCount = 0

var isFinished = false

while isFinished == false {
    if let new = checkMove(moveDown) {
        update(new)
    } else if let new = checkMove(moveDownLeft) {
        update(new)
    } else if let new = checkMove(moveDownRight) {
        update(new)
    } else {
        snowCount += 1
        currentSnow = entry
    }
}

print(snowCount - 1)

// part two

matrix = cleanMatrix

matrix.append(Array<String>(repeating: ".", count: width + height))
matrix.append(Array<String>(repeating: "#", count: width + height))

currentSnow = entry
snowCount = 0
isFinished = false

while isFinished == false {
    if let new = checkMove(moveDown) {
        update(new)
    } else if let new = checkMove(moveDownLeft) {
        update(new)
    } else if let new = checkMove(moveDownRight) {
        update(new)
    } else {
        if currentSnow == entry {
            isFinished = true
            continue
        }
        snowCount += 1
        currentSnow = entry
    }
}

print(snowCount + 1)
