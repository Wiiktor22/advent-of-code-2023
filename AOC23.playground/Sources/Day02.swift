import Foundation

public struct Day02 {
    public let data: [String]
    
    public init(resourceName: String) {
        self.data = Utils.readFile(resourceName: resourceName)
    }
    
    let limit: [String: Int] = [
        "blue": 14,
        "red": 12,
        "green": 13
    ]
    
    public func partOne() -> Int? {
        data.reduce(0) { partialResult, inputLine in
            // STEP: Find game ID
            let indexOfTheFirstSpace = inputLine.firstIndex(of: " ")
            let indexOfTheFirstColon = inputLine.firstIndex(of: ":")
            
            guard let indexOfTheFirstSpace = indexOfTheFirstSpace, let indexOfTheFirstColon = indexOfTheFirstColon else { return 0 }
            
            let id = inputLine[indexOfTheFirstSpace..<indexOfTheFirstColon].filter { char in char != " "}
            
            let indexToDrop: Int = inputLine.distance(from: inputLine.startIndex, to: indexOfTheFirstColon) + 2
            let bags = inputLine.dropFirst(indexToDrop).components(separatedBy: ";")
            
            let filteredBags = bags.filter { bag in
                var score: [String: Int] = [
                    "blue": 0,
                    "red": 0,
                    "green": 0
                ]
                
                let cubes = bag.components(separatedBy: ",").map { bag in bag.filter { char in char != " " } }
                
                cubes.forEach { cube in
                    let color = score.keys.first { cubeColor in cube.contains(cubeColor) }!
                    
                    let colorAsArray = Array(color)
                    let indexOfFirstColorLeter = cube.firstIndex(of: colorAsArray[0])
                    
                    let numberOfCubes = Int(cube[..<indexOfFirstColorLeter!])!
                    
                    if let scoreForTheColor = score[color] {
                        score.updateValue(scoreForTheColor + numberOfCubes, forKey: color)
                    }
                }
                
                return limit["blue"]! >= score["blue"]! && limit["red"]! >= score["red"]! && limit["green"]! >= score["green"]!
            }
            
            return bags.count == filteredBags.count ? (Int(id)! + partialResult) : partialResult
        }
    }
    
    public func partTwo() -> Int {
        data.reduce(0) { partialResult, inputLine in
            let indexOfTheFirstColon = inputLine.firstIndex(of: ":")!
            let indexToDrop: Int = inputLine.distance(from: inputLine.startIndex, to: indexOfTheFirstColon) + 2
            
            let bags = inputLine.dropFirst(indexToDrop).components(separatedBy: ";")
            
            var score: [String: Int] = [
                "blue": 0,
                "red": 0,
                "green": 0
            ]
            
            bags.forEach { bag in
                let cubes = bag.components(separatedBy: ",").map { bag in bag.filter { char in char != " " } }
                
                cubes.forEach { cube in
                    let color = score.keys.first { cubeColor in cube.contains(cubeColor) }!
                    
                    let colorAsArray = Array(color)
                    let indexOfFirstColorLeter = cube.firstIndex(of: colorAsArray[0])
                    
                    let numberOfCubes = Int(cube[..<indexOfFirstColorLeter!])!
                    
                    if let colorEntryInScore = score[color] {
                        if (numberOfCubes > colorEntryInScore) {
                            score.updateValue(numberOfCubes, forKey: color)
                        }
                    }
                }
            }
            
            return partialResult + score.values.reduce(1) { partialScore, singleScore in
                partialScore * singleScore
            }
        }
    }
}
