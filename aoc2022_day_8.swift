import Foundation

let input = """
30373
25512
65332
33549
35390
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: true).map({ String($0) })

var matrix: [[Int]] = []
inputStrings.forEach({ matrix.append($0.map({ Int(String($0)) ?? 0 })) })

let size = matrix.count

// helpers

func isBound(row: Int, column: Int) -> Bool {
    return row == 0 || column == 0 || row == size - 1 || column == size - 1
}

func checkTopIsVisible(row: Int, column: Int) -> Bool {
    var index = row - 1
    while index != -1 {
        if matrix[row][column] > matrix[index][column] {
            index -= 1
        } else {
            return false
        }
    }
    return true
}

func checkBottomIsVisible(row: Int, column: Int) -> Bool {
    var index = row + 1
    while index < size {
        if matrix[row][column] > matrix[index][column] {
            index += 1
        } else {
            return false
        }
    }
    return true
}

func checkLeftIsVisible(row: Int, column: Int) -> Bool {
    var index = column - 1
    while index >= 0 {
        if matrix[row][column] > matrix[row][index] {
            index -= 1
        } else {
            return false
        }
    }
    return true
}

func checkRightIsVisible(row: Int, column: Int) -> Bool {
    var index = column + 1
    while index < size {
        if matrix[row][column] > matrix[row][index] {
            index += 1
        } else {
            return false
        }
    }
    return true
}

func isVisible(row: Int, column: Int) -> Bool {
    let element = matrix[row][column]
    if isBound(row: row, column: column) {
        return true
    }

    return checkTopIsVisible(row: row, column: column) ||
    checkBottomIsVisible(row: row, column: column) ||
    checkLeftIsVisible(row: row, column: column) ||
    checkRightIsVisible(row: row, column: column)
}

func topTreeCount(row: Int, column: Int) -> Int {
    var count = 0
    var index = row - 1
    while index >= 0 {
        if matrix[row][column] > matrix[index][column] {
            count += 1
        } else {
            return count + 1
        }
        index -= 1
    }
    return count
}

func bottomTreeCount(row: Int, column: Int) -> Int {
    var count = 0
    var index = row + 1
    while index < size {
        if matrix[row][column] > matrix[index][column] {
            count += 1
        } else {
            return count + 1
        }
        index += 1
    }
    return count
}

func leftTreeCount(row: Int, column: Int) -> Int {
    var count = 0
    var index = column - 1
    while index >= 0 {
        if matrix[row][column] > matrix[row][index] {
            count += 1
        } else {
            return count + 1
        }
        index -= 1
    }
    return count
}

func rightTreeCount(row: Int, column: Int) -> Int {
    var count = 0
    var index = column + 1
    while index < size {
        if matrix[row][column] > matrix[row][index] {
            count += 1
        } else {
            return count + 1
        }
        index += 1
    }
    return count
}

// part one

var count = 0

for i in 0..<size {
    for j in 0..<size {
        if isVisible(row: i, column: j) {
            count += 1
        }
    }
}

print(count)

// part two

var maxM = 0

for i in 0..<size {
    for j in 0..<size {
        if isBound(row: i, column: j) {
            continue
        }
        let result = topTreeCount(row: i, column: j)
        * bottomTreeCount(row: i, column: j)
        * leftTreeCount(row: i, column: j)
        * rightTreeCount(row: i, column: j)

        if result > maxM {
            maxM = result
        }
    }
}

print(maxM)
