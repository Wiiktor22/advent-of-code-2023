import Foundation

public struct Day06 {
    public let data: [String]
    
    public init(resourceName: String) {
        self.data = Utils.readFile(resourceName: resourceName)
    }
    
    func getNumbersFromInputLinePartOne(inputLine: String) -> [Int] {
        var isLastItemANumber = false
        
        return inputLine.reduce([]) { result, char in
            if (char.isNumber) {
                var copyOfTheResult = result.map { $0 }
                
                if (isLastItemANumber) {
                    copyOfTheResult[result.count - 1] = Int("\(result.last!)\(char)")!
                } else {
                    isLastItemANumber = true
                    copyOfTheResult.append(Int(String(char))!)
                }
                return copyOfTheResult
            } else {
                isLastItemANumber = false
                return result
            }
        }
    }

    func prepareDataPartOne() -> [(Int, Int)] {
        let times = getNumbersFromInputLinePartOne(inputLine: data[0])
        let distances = getNumbersFromInputLinePartOne(inputLine: data[1])
        return Array(zip(times, distances))
    }

    func simulateRace(_ race: (Int, Int)) -> Int {
        let indexes = Array(0...race.0)
        
        let indexFrom = indexes.first { speed in
            let timeLeft = race.0 - speed
            let distanceInThisRound = timeLeft * speed
            return distanceInThisRound > race.1
        }!
        
        let indexTo = indexes.last { speed in
            let timeLeft = race.0 - speed
            let distanceInThisRound = timeLeft * speed
            return distanceInThisRound > race.1
        }!

        return indexTo - indexFrom + 1
    }

    public func partOne() -> Int {
        let races = prepareDataPartOne()
        return races.map { simulateRace($0) }.reduce(1, { $0 * $1 } )
    }

    func getNumbersFromInputLinePartTwo(inputLine: String) -> Int {
        let stringRepresentationOfTheNumber = inputLine.reduce("") { result, char in
            if (char.isNumber) {
                return result + String(char)
            }
            return result
        }
        return Int(stringRepresentationOfTheNumber)!
    }

    public func partTwo() -> Int {
        let time = getNumbersFromInputLinePartTwo(inputLine: data[0])
        let distance = getNumbersFromInputLinePartTwo(inputLine: data[1])
        
        return simulateRace((time, distance))
    }

}
