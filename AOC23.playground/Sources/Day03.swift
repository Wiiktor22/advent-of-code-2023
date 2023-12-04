import Foundation

public struct Day03 {
    public let data: [String]
    
    public init(resourceName: String) {
        self.data = Utils.readFile(resourceName: resourceName)
    }
    
    func hasSymbolAsAdjacent(engineScheme: [[String.Element]], lineIndex: Int, minFrameIndex: Int, maxFrameIndex: Int, maxLineConstraint: Int, maxFrameConstraint: Int) -> Bool {
        let linesToCheck = {
            var lines: [Int] = []
            
            if (lineIndex > 0) {
                lines.append(lineIndex - 1)
            }
            
            lines.append(lineIndex)
            
            if (maxLineConstraint > lineIndex) {
                lines.append(lineIndex + 1)
            }
            
            return lines
        }()
        
        let indexesToCheck = {
            var indexes: [Int] = Array(minFrameIndex...maxFrameIndex)
            
            if (minFrameIndex > 0) {
                indexes.insert(minFrameIndex - 1, at: 0)
            }
            
            if (maxFrameConstraint > maxFrameIndex) {
                indexes.append(maxFrameIndex + 1)
            }
            
            return indexes
        }()
        
        let itemsToCheck = {
            var items: [String.Element] = []
            
            for internalLineIndex in linesToCheck {
                for itemIndex in indexesToCheck {
                    let item = engineScheme[internalLineIndex][itemIndex]
                    if (!item.isNumber) {
                        items.append(item)
                    }
                }
            }
            
            return items
        }()
        
        return itemsToCheck.contains { $0 != "." }
    }
    
    public func partOne() -> Int? {
        let engineScheme = data.map { Array($0) }
        
        let minLineIndex = 0
        let maxLineIndex = engineScheme.count - 1
        
        let minItemIndex = 0
        let maxItemIndex = (engineScheme.first?.count ?? 1) - 1
        
        var result = 0
        
        var currentNumber = ""
        
        for lineIndex in minLineIndex...maxLineIndex {
            for itemIndex in minItemIndex...maxItemIndex {
                let item = engineScheme[lineIndex][itemIndex]
                
                if (item.isNumber) {
                    currentNumber = String("\(currentNumber)\(item)")
                    
                    if (itemIndex == maxItemIndex) {
                        let shouldBeIncludedInResult = hasSymbolAsAdjacent(
                            engineScheme: engineScheme,
                            lineIndex: lineIndex,
                            minFrameIndex: (itemIndex - currentNumber.count + 1),
                            maxFrameIndex: itemIndex,
                            maxLineConstraint: maxLineIndex,
                            maxFrameConstraint: maxItemIndex
                        )
                        
                        if (shouldBeIncludedInResult) {
                            result += Int(currentNumber)!
                        }
                        
                        currentNumber = ""
                    } else {
                        continue
                    }
                    
                }
                
                if (currentNumber != "" && !item.isNumber) {
                    let shouldBeIncludedInResult = hasSymbolAsAdjacent(
                        engineScheme: engineScheme,
                        lineIndex: lineIndex,
                        minFrameIndex: (itemIndex - currentNumber.count),
                        maxFrameIndex: itemIndex - 1,
                        maxLineConstraint: maxLineIndex,
                        maxFrameConstraint: maxItemIndex
                    )
                    
                    if (shouldBeIncludedInResult) {
                        result += Int(currentNumber)!
                    }
                    
                    currentNumber = ""
                }
            }
        }
        
        return result
    }
    
    func extendNumber(engineScheme: [[String.Element]], line: Int, index: Int, acc: String, dots: [String]) -> String {
        let item = engineScheme[line][index]
        
        if (dots.isEmpty) {
            if (1...138 ~= index) {
                let itemOnTheLeft = engineScheme[line][index - 1]
                if (itemOnTheLeft.isNumber) {
                    return extendNumber(engineScheme: engineScheme, line: line, index: index - 1, acc: "\(itemOnTheLeft)\(acc)", dots: dots)
                } else {
                    return extendNumber(engineScheme: engineScheme, line: line, index: index + (acc.count - 1), acc: acc, dots: ["."])
                }
            } else {
                return extendNumber(engineScheme: engineScheme, line: line, index: index + (acc.count - 1), acc: acc, dots: ["."])
            }
        } else if (dots.count == 1) {
            if (1...138 ~= index) {
                let itemOnTheRight = engineScheme[line][index + 1]
                if (itemOnTheRight.isNumber) {
                    return extendNumber(engineScheme: engineScheme, line: line, index: index + 1, acc: "\(acc)\(itemOnTheRight)", dots: dots)
                } else {
                    return extendNumber(engineScheme: engineScheme, line: line, index: index, acc: acc, dots: [".", "."])
                }
            } else {
                return extendNumber(engineScheme: engineScheme, line: line, index: index, acc: acc, dots: [".", "."])
            }
        } else {
            return acc
        }
    }
    
    func getNumbersAroundGear(engineScheme: [[String.Element]], lineIndex: Int, minFrameIndex: Int, maxFrameIndex: Int, maxLineConstraint: Int, maxFrameConstraint: Int) -> [Int] {
        let linesToCheck = {
            var lines: [Int] = []
            
            if (lineIndex > 0) {
                lines.append(lineIndex - 1)
            }
            
            lines.append(lineIndex)
            
            if (maxLineConstraint > lineIndex) {
                lines.append(lineIndex + 1)
            }
            
            return lines
        }()
        
        let indexesToCheck = Array(minFrameIndex...maxFrameIndex)
        
        var numbers: Set<Int> = []
        
        for line in linesToCheck {
            for index in indexesToCheck {
                let item = engineScheme[line][index]
                
                if (item.isNumber) {
                    let foundNumberAsString = extendNumber(engineScheme: engineScheme, line: line, index: index, acc: "\(item)", dots: [])
                    numbers.insert(Int(foundNumberAsString)!)
                }
            }
        }
        
        return Array(numbers)
    }
    
    public func partTwo() -> Int {
        let engineScheme = data.map { Array($0) }
        
        let minLineIndex = 0
        let maxLineIndex = engineScheme.count - 1
        
        let minItemIndex = 0
        let maxItemIndex = (engineScheme.first?.count ?? 1) - 1
        
        var result = 0
        
        for lineIndex in minLineIndex...maxLineIndex {
            for itemIndex in minItemIndex...maxItemIndex {
                if (engineScheme[lineIndex][itemIndex] == "*") {
                    let foundNumbers = getNumbersAroundGear(
                        engineScheme: engineScheme,
                        lineIndex: lineIndex,
                        minFrameIndex: (itemIndex - 1) >= 0 ? itemIndex - 1 : 0,
                        maxFrameIndex: (itemIndex + 1) <= 139 ? (itemIndex + 1) : 139,
                        maxLineConstraint: maxLineIndex,
                        maxFrameConstraint: maxItemIndex
                    )
                    
                    if (foundNumbers.count == 2) {
                        let gearRation = foundNumbers[0] * foundNumbers[1]
                        result += gearRation
                    }
                }
            }
        }
        
        return result
    }
}
