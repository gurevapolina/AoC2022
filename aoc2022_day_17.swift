import Foundation

let input = """
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""

let inputStrings = input.split(separator: "\n").map({ String($0) })
let inputString = inputStrings.first ?? ""

enum Move {
    case left
    case right
    
    init?(_ str: Character) {
        if str == ">" {
            self = .right
        } else if str == "<" {
            self = .left
        } else {
            return nil
        }
    }
}

enum Shape {
    case minus
    case plus
    case angle
    case line
    case square
    
    var next: Shape {
        switch self {
        case .minus:
            return .plus
        case .plus:
            return .angle
        case .angle:
            return .line
        case .line:
            return .square
        case .square:
            return .minus
        }
    }
    
    var shape: [[String]] {
        switch self {
        case .minus:
            return [[".", ".", "@", "@", "@", "@", "."]]
        case .plus:
            return [[".", ".", ".", "@", ".", ".", "."],
                    [".", ".", "@", "@", "@", ".", "."],
                    [".", ".", ".", "@", ".", ".", "."]]
        case .angle:
            return [[".", ".", ".", ".", "@", ".", "."],
                    [".", ".", ".", ".", "@", ".", "."],
                    [".", ".", "@", "@", "@", ".", "."]]
        case .line:
            return [[".", ".", "@", ".", ".", ".", "."],
                    [".", ".", "@", ".", ".", ".", "."],
                    [".", ".", "@", ".", ".", ".", "."],
                    [".", ".", "@", ".", ".", ".", "."]]
        case .square:
            return [[".", ".", "@", "@", ".", ".", "."],
                    [".", ".", "@", "@", ".", ".", "."]]
        }
    }
    
    var numberOfLines: Int {
        let index = matrix.firstIndex(where: { $0.contains("@") }) ?? 0
        switch self {
        case .minus:
            return 1 + index
        case .plus:
            return 3 + index
        case .angle:
            return 3 + index
        case .line:
            return 4 + index
        case .square:
            return 2 + index
        }
    }
}

let moves = inputString.compactMap({ Move($0) })

var moveIndex = 0 {
    didSet {
        if moveIndex == moves.count {
            moveIndex = 0
        }
    }
}

var width = 7
let emptyLine = Array<String>(repeating: ".", count: width)

var blocksCount = 2022
var counter = 0

var matrix: [[String]] = []
var block = Shape.minus

while counter < blocksCount {
    matrix = block.shape + [emptyLine, emptyLine, emptyLine] + matrix

    moveBlock()
    
    block = block.next
    counter += 1
}

func moveBlock() {
    moveTo(moves[moveIndex])
    moveIndex += 1

    while canMoveDown() {
        moveDown()
        moveTo(moves[moveIndex])
        moveIndex += 1
    }

    finishMoving()
}

func moveDown() {
    var index = block.numberOfLines - 1
    while index >= 0 {
        for j in 0..<width {
            if matrix[index][j] == "@" {
                matrix[index][j] = "."
                matrix[index + 1][j] = "@"
            }
        }
        index -= 1
    }
    if matrix.first?.contains("#") == false {
        matrix.removeFirst()
    }
}

func moveTo(_ direction: Move) {
    if direction == .right && canMoveRight() {
        for line in 0..<block.numberOfLines {
            var index = width - 2
            while index >= 0 {
                if matrix[line][index] == "@" {
                    matrix[line][index] = "."
                    matrix[line][index + 1] = "@"
                }
                index -= 1
            }
        }
    }
    
    if direction == .left && canMoveLeft() {
        for line in 0..<block.numberOfLines {
            var index = 1
            while index < width  {
                if matrix[line][index] == "@" {
                    matrix[line][index] = "."
                    matrix[line][index - 1] = "@"
                }
                index += 1
            }
        }
    }
}

func canMoveDown() -> Bool {
    let lines = matrix.prefix(block.numberOfLines + 1)
    
    guard block.numberOfLines + 1 == lines.count else { return false }
    
    for index in 0..<lines.count - 1 {
        for j in 0..<width {
            if lines[index][j] == "@" && lines[index + 1][j] == "#" {
                return false
            }
        }
    }
    return true
}

func canMoveRight() -> Bool {
    let lines = matrix.prefix(block.numberOfLines)
    
    for index in 0..<lines.count {
        if lines[index][width - 1] == "@" {
            return false
        }
        for j in 0..<width - 1 {
            if lines[index][j] == "@" && lines[index][j + 1] == "#" {
                return false
            }
        }
    }
    return true
}

func canMoveLeft() -> Bool {
    let lines = matrix.prefix(block.numberOfLines)
    
    for index in 0..<lines.count {
        if lines[index][0] == "@" {
            return false
        }
        for j in 1..<width {
            if lines[index][j] == "@" && lines[index][j - 1] == "#" {
                return false
            }
        }
    }
    return true
}

func finishMoving() {
    for index in 0..<block.numberOfLines {
        for j in 0..<width {
            if matrix[index][j] == "@" {
                matrix[index][j] = "#"
            }
        }
    }
}

print(matrix.count)
