import Foundation

public struct Day01 {
    let data: [String]
    
    public init(resourceName: String) {
        self.data = Utils.readFile(resourceName: resourceName)
    }
    
    let lettersDictionary: [String: Int] = [
        "one" : 1,
        "two" : 2,
        "three" : 3,
        "four" : 4,
        "five" : 5,
        "six" : 6,
        "seven" : 7,
        "eight" : 8,
        "nine" : 9
    ]
    
    public func partOne() -> Int {
        return data.reduce(0) { partialResult, calibration in
            let directions = Array(calibration).filter { char in
                (Int(String(char)) ?? -100) != -100
            }
            
            if let firstNum = directions.first, let secondNum = directions.last {
                return Int("\(firstNum)\(secondNum)")! + partialResult
            } else {
                return partialResult
            }
        }
    }
    
    public func partTwo() -> Int {
        return data.reduce(0) { partialResult, calibration in
            let arrayOfCharacters = Array(calibration)
            var codedCalibration = calibration
            
            var digits: [Int] = []
            
            for index in 0..<calibration.count {
                // STEP: 1 Look for numbers
                if let num = Int(String(arrayOfCharacters[index])) {
                    digits.append(num)
                }
                
                // STEP: 2 Look for letters
                for (stringRepresentation, numberRepresentation) in lettersDictionary {
                    if (codedCalibration.starts(with: stringRepresentation)) {
                        digits.append(numberRepresentation)
                    }
                }
                
                codedCalibration = String(codedCalibration.dropFirst())
            }
            
            return Int("\(digits.first!)\(digits.last!)")! + partialResult
        }
    }
}
