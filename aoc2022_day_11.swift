import Foundation

let input = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: true).map({ String($0) })

// helpers

class Command {
    var holder: Int = 0
    var operation: ((_ old: Int) -> Int) = { _ in return 0}
    var divisibleBy: Int = 0
    var trueReceiver: Int = 0
    var falseReceiver: Int = 0
}

func parseName(_ string: String) -> Int {
    let monkeyName = Int(String(inputStrings[i].suffix(inputStrings[i].count - "Monkey ".count))
        .replacingOccurrences(of: ":", with: "")
    ) ?? 0
    return monkeyName
}

func parseItems(_ string: String) -> [Int] {
    let split = inputStrings[i].suffix(inputStrings[i].count - "  Starting items: ".count)
        .split(separator: ",")
    return split
        .compactMap({ String($0).replacingOccurrences(of: " ", with: "") })
        .compactMap({ Int($0) })
}

func parseOperation(_ string: String) -> ((Int) -> Int) {
    let operation = inputStrings[i].suffix(inputStrings[i].count - "  Operation: new = ".count)
    let split = operation.split(separator: " ")
    
    var operand2 = 0
    var useOldInsteadOperand = false
    
    if split[2] == "old" {
        useOldInsteadOperand = true
    } else {
        operand2 = Int(split[2]) ?? 0
    }
    
    switch split[1] {
    case "+":
        return { old in
            if useOldInsteadOperand {
                return old + old
            } else {
                return old + operand2
            }
        }
        
    case "*":
        return { old in
            if useOldInsteadOperand {
                return old * old
            } else {
                return old * operand2
            }
        }
        
    default:
        return { _ in return 0 }
    }
}

func parseDividable(_ string: String) -> Int {
    let value = Int(String(inputStrings[i].suffix(inputStrings[i].count - "  Test: divisible by ".count))) ?? 0
    return value
}

func parseTestTrue(_ string: String) -> Int {
    let value = Int(String(inputStrings[i].suffix(inputStrings[i].count - "    If true: throw to monkey ".count))) ?? 0
    return value
}

func parseTestFalse(_ string: String) -> Int {
    let value = Int(String(inputStrings[i].suffix(inputStrings[i].count - "    If false: throw to monkey ".count))) ?? 0
    return value
}

var monkeyItemsDict: [Int: [Int]] = [:]

var commands: [Command] = []
var i = 0

while i < inputStrings.count {
    let command = Command()
    // name
    if inputStrings[i].hasPrefix("Monkey ") {
        let name = parseName(inputStrings[i])
        command.holder = name
        i += 1
        
        // worries
        if inputStrings[i].hasPrefix("  Starting items: ") {
            let values = parseItems(inputStrings[i])
            monkeyItemsDict[name] = values
            i += 1
            
            // operation
            if inputStrings[i].hasPrefix("  Operation: new = ") {
                let operation = parseOperation(inputStrings[i])
                command.operation = operation
                i += 1
                
                // test
                if inputStrings[i].hasPrefix("  Test: divisible by ") {
                    let value = parseDividable(inputStrings[i])
                    command.divisibleBy = value
                    i += 1
                    
                    // test true
                    if inputStrings[i].hasPrefix("    If true: throw to monkey ") {
                        let value = parseTestTrue(inputStrings[i])
                        command.trueReceiver = value
                        i += 1
                        
                        // test false
                        if inputStrings[i].hasPrefix("    If false: throw to monkey ") {
                            let value = parseTestFalse(inputStrings[i])
                            command.falseReceiver = value
                            i += 1
                        }
                    }
                }
            }
        }
    }
    commands.append(command)
}

// part one

var monkeyItemsCountDict: [Int: Int] = [:]
var roundCount = 20

var monkeyItemsDictPartOne = monkeyItemsDict

for _ in 0..<roundCount {
    for command in commands {
        let items = monkeyItemsDictPartOne[command.holder] ?? []
        for item in items {
            let newWorry = command.operation(item) / 3
            
            if newWorry % command.divisibleBy == 0 {
                monkeyItemsDictPartOne[command.trueReceiver]?.append(newWorry)
            } else {
                monkeyItemsDictPartOne[command.falseReceiver]?.append(newWorry)
            }
            monkeyItemsDictPartOne[command.holder]?.removeFirst()
            
            if let value = monkeyItemsCountDict[command.holder] {
                monkeyItemsCountDict[command.holder] = value + 1
            } else {
                monkeyItemsCountDict[command.holder] = 1
            }
        }
    }
}

var values = monkeyItemsCountDict.values.sorted(by: >)
print(values[0] * values[1])

// part two

monkeyItemsCountDict = [:]
roundCount = 10000

var mod = commands.map({ $0.divisibleBy }).reduce(1, { $0 * $1 })

for _ in 0..<roundCount {
    for command in commands {
        let items = monkeyItemsDict[command.holder] ?? []
        for item in items {
            let newWorry = command.operation(item) % mod
            
            if newWorry % command.divisibleBy == 0 {
                monkeyItemsDict[command.trueReceiver]?.append(newWorry)
            } else {
                monkeyItemsDict[command.falseReceiver]?.append(newWorry)
            }
            monkeyItemsDict[command.holder]?.removeFirst()
            
            if let value = monkeyItemsCountDict[command.holder] {
                monkeyItemsCountDict[command.holder] = value + 1
            } else {
                monkeyItemsCountDict[command.holder] = 1
            }
        }
    }
}

values = monkeyItemsCountDict.values.sorted(by: >)
print(values[0] * values[1])

