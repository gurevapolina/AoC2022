let input = """
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
"""

let inputString = input.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) }).first ?? ""

// helpers

func positionOfSymbol(_ string: String, keyLength: Int) -> Int {
    var string = string
    var count = 0
    var done = false

    while done == false {
        if Set(string.prefix(keyLength)).count == keyLength {
            done = true
        } else {
            count += 1
            string.removeFirst()
        }
    }
    return count + keyLength
}


// part one

print(positionOfSymbol(inputString, keyLength: 4))

// part two

print(positionOfSymbol(inputString, keyLength: 14))

