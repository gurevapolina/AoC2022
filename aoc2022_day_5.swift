import Foundation

let input = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: true).map({ String($0) })

// helpers

var width: Int {
    return inputStrings.first(where: { $0.hasPrefix(" 1") })?.split(separator: " ").count ?? 0
}

var height: Int {
    return inputStrings.firstIndex(where: { $0.hasPrefix(" 1") }) ?? 0
}

func executeCommand(command: String, reversed: Bool) {
    let numbers = command.replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "move", with: " ")
        .replacingOccurrences(of: "from", with: " ")
        .replacingOccurrences(of: "to", with: " ")
        .split(separator: " ")
        .compactMap({ Int(String($0)) })

    let amount = numbers[0]
    let from = numbers[1] - 1
    let to = numbers[2] - 1

    let lastN = stacks[from].suffix(amount)
    stacks[from].removeLast(amount)

    if reversed {
        stacks[to] += lastN.reversed()
    } else {
        stacks[to] += lastN
    }
}

func createStacks() -> [[String]] {
    var stringsBySymbols = inputStrings.prefix(height).compactMap({ string in
        var string = string
        var strings: [String] = []
        for _ in 0..<width {
            var prefix = string.prefix(3)
            let symbol = prefix.replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: " ", with: "")
            strings.append(symbol)

            if string.isEmpty == false {
                string.removeFirst(string.count == 3 ? 3 : 4)
            }
        }
        return strings
    })

    var stacks: [[String]] = []

    for index in 0..<width {
        var newStack: [String] = []
        for string in stringsBySymbols {
            if string[index] != "" {
                newStack.append(string[index])
            }
        }
        stacks.append(newStack.reversed())
    }

    return stacks
}

let commands = inputStrings.suffix(inputStrings.count - height - 1)

// part one

var stacks = createStacks()
commands.forEach({ executeCommand(command: $0, reversed: true) })

let resultPartOne = stacks.compactMap({ $0.last }).joined()
print(resultPartOne)

// part two

stacks = createStacks()
commands.forEach({ executeCommand(command: $0, reversed: false) })

let resultPartTwo = stacks.compactMap({ $0.last }).joined()
print(resultPartTwo)
