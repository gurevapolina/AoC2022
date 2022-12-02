let input = """
A Y
B X
C Z
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: false)

// helpers

enum GameResult {
    case draw
    case lose
    case defeat
    
    init?(value: String) {
        switch value {
        case "X":
            self = .lose
        case "Y":
            self = .draw
        case "Z":
            self = .defeat

        default:
            return nil
        }
    }
    
    init(myChoice: Choice, opponentChoice: Choice) {
        switch (myChoice, opponentChoice) {
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            self = .lose
        case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
            self = .draw
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            self = .defeat
        }
    }
    
    var numberOfPoints: Int {
        switch self {
        case .lose:
            return 0
        case .draw:
            return 3
        case .defeat:
            return 6
        }
    }
    
    func myChoice(with opponentChoice: Choice) -> Choice {
        switch (self, opponentChoice) {
        case (.draw, .rock), (.lose, .paper), (.defeat, .scissors):
            return .rock
        case (.draw, .paper), (.lose, .scissors), (.defeat, .rock):
            return .paper
        case (.draw, .scissors), (.lose, .rock), (.defeat, .paper):
            return .scissors
        }
    }
}

enum Choice {
    case rock
    case paper
    case scissors
    
    init?(value: String, isOpponent: Bool) {
        switch (value, isOpponent) {
        case ("A", true), ("X", false):
            self = .rock
        
        case ("B", true), ("Y", false):
            self = .paper
            
        case ("C", true), ("Z", false):
            self = .scissors
            
        default:
            return nil
        }
    }
    
    var pointsForChoice: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
}

func points(opponentChoice: Choice, myChoice: Choice) -> Int {
    let gameResult = GameResult(myChoice: myChoice, opponentChoice: opponentChoice)
    return myChoice.pointsForChoice + gameResult.numberOfPoints
}

// part one

let inputPairsPartOne: [(Choice, Choice)] = inputStrings.compactMap { inputString in
    let split = inputString.split(separator: " ").map({ String($0) })
    guard let opponentsChoise = Choice(value: split[0], isOpponent: true),
          let myChoise = Choice(value: split[1], isOpponent: false)
    else { return nil }
    return (opponentsChoise, myChoise)
}

let sumOfPointsPartOne = inputPairsPartOne.reduce(0, { $0 + points(opponentChoice: $1.0, myChoice: $1.1) })
print(sumOfPointsPartOne)


// part two

let inputPairsPartTwo: [(Choice, GameResult)] = inputStrings.compactMap { inputString in
    let split = inputString.split(separator: " ").map({ String($0) })
    guard let opponentsChoise = Choice(value: split[0], isOpponent: true),
          let gameResult = GameResult(value: split[1])
    else { return nil }
    return (opponentsChoise, gameResult)
}

let chosenPairs: [(Choice, Choice)] = inputPairsPartTwo.compactMap { opponentChoice, gameResult in
    return (opponentChoice, gameResult.myChoice(with: opponentChoice))
}

let sumOfPointsPartTwo = chosenPairs.reduce(0, { $0 + points(opponentChoice: $1.0, myChoice: $1.1) })
print(sumOfPointsPartTwo)
