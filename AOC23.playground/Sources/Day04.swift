import Foundation

public struct Day04 {
    public let data: [String]
    
    public init(resourceName: String) {
        self.data = Utils.readFile(resourceName: resourceName)
    }
    
    func getCardId(inputLine: String) -> String? {
        let indexOfTheFirstSpace = inputLine.firstIndex(of: " ")
        let indexOfTheFirstColon = inputLine.firstIndex(of: ":")
        
        guard let foundIndexOfTheFirstSpace = indexOfTheFirstSpace, let foundIndexOfTheFirstColon = indexOfTheFirstColon else { return nil }
        
        return inputLine[foundIndexOfTheFirstSpace..<foundIndexOfTheFirstColon].filter { char in char != " "}
    }

    func getWinningNumber(inputLine: String) -> [Int]? {
        let indexOfTheFirstColon = inputLine.firstIndex(of: ":")
        let indexOfTheBreakSign = inputLine.firstIndex(of: "|")
        
        guard let foundIndexOfTheFirstColon = indexOfTheFirstColon, let foundIndexOfTheBreakSign = indexOfTheBreakSign else { return nil }
        
        let numberAsString = inputLine[foundIndexOfTheFirstColon..<foundIndexOfTheBreakSign].dropFirst(2)
        
        return numberAsString.components(separatedBy: " ").compactMap { Int($0) }
    }

    func getPlayingNumbers(inputLine: String) -> [Int]? {
        let indexOfTheBreakSign = inputLine.firstIndex(of: "|")
        
        guard let foundIndexOfTheBreakSign = indexOfTheBreakSign else { return nil }
        
        let numberAsString = inputLine[foundIndexOfTheBreakSign...].dropFirst(2)
        
        return numberAsString.components(separatedBy: " ").compactMap { Int($0) }
    }

    public func partOne() -> Int? {
        data.reduce(0) { sum, line in
            guard let winningNumbers = getWinningNumber(inputLine: line) else { return sum  }
            
            guard let playingNumbers = getPlayingNumbers(inputLine: line) else { return sum }
            
            let coveredNumbers = playingNumbers.filter {
                winningNumbers.contains($0)
            }
            
            if (coveredNumbers.isEmpty) {
                return sum
            } else {
                let round = Int(pow(2.0, Double(coveredNumbers.count - 1)))
                return sum + round
            }
        }
    }

    public func partTwo() -> Int? {
        var cardsToCheck: [(Int, Int)] = {
            Array(1...204).map { index in
                (index, 1)
            }
        }()
        
        return data.reduce(0) { sum, line in
            guard let cardId = getCardId(inputLine: line) else { return sum }
            
            guard let winningNumbers = getWinningNumber(inputLine: line) else { return sum }
            
            guard let playingNumbers = getPlayingNumbers(inputLine: line) else { return sum }
            
            let numberOfcoveredNumbers = playingNumbers.filter {
                winningNumbers.contains($0)
            }.count
            
            let newCardsToCheck = Array((Int(cardId)! + 1)..<(Int(cardId)! + 1 + numberOfcoveredNumbers))
            
            let multiplier = cardsToCheck.first { elem in
                elem.0 == Int(cardId)!
            }!.1
            
            cardsToCheck[Int(cardId)! - 1].1 = 0
            
            for _ in 1...multiplier {
                for index in newCardsToCheck {
                    cardsToCheck[index - 1].1 += 1
                }
            }
            
            return sum + multiplier
        }
    }
}
