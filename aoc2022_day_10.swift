let input = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })

// part one

var x = 1
var index = 1
var sum = 0

func appendSumIfNeeded() {
    if index == 20 || index == 60 || index == 100 || index == 140 || index == 180 || index == 220 {
        sum += (index * x)
    }
}

func executePartOne(_ command: String) {
    switch command {
    case "noop":
        appendSumIfNeeded()
    default:
        let split = command.split(separator: " ").map({ String($0) })
        let value = Int(split[1]) ?? 0

        appendSumIfNeeded()
        index += 1
        appendSumIfNeeded()
        x += value
    }
}

for command in inputStrings {
    executePartOne(command)
    index += 1
}

print(sum)

// part two

var sprite = "###....................................."
var initialSprite = "###....................................."

var result: [String] = [""]

index = 0
var currentLine = 0

var spritePos = 0

func updateResult() {
    currentLine = index / 40
    if currentLine == result.count {
        sprite = initialSprite
        result.append("")
    }
    
    let index = index % 40
    
    let stringIndex = String.Index(utf16Offset: index, in: sprite)
    if sprite[stringIndex] == "#" {
        result[currentLine].append("#")
    } else {
        result[currentLine].append(".")
    }
}

func updateSprite(value: Int) {
    spritePos += value
    var newSprite = ""
    
    for i in 0..<40 {
        if (spritePos...(spritePos + 2)).contains(i) {
            newSprite.append("#")
        } else {
            newSprite.append(".")
        }
    }
    sprite = newSprite
}

func executePartTwo(_ command: String) {
    switch command {
    case "noop":
        updateResult()
    default:
        let split = command.split(separator: " ").map({ String($0) })
        let value = Int(split[1]) ?? 0

        updateResult()
        index += 1
        updateResult()
        updateSprite(value: value)
    }
}

for command in inputStrings {
    executePartTwo(command)
    index += 1
}

result.forEach({ print($0) })
