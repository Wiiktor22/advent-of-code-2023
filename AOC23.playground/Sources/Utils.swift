import Foundation

public struct Utils {
    public static func readFile(resourceName: String) -> [String] {
        if let fileURL = Bundle.main.url(forResource: resourceName, withExtension: "txt") {
            do {
                let content = try String(contentsOf: fileURL)
                var x = content.components(separatedBy: "\n")
                x.removeAll { data in
                    data.isEmpty
                }
                return x
            } catch {
                fatalError("Enable to read from: \(resourceName) file")
            }
        } else {
            fatalError("Enable to find: \(resourceName) file")
        }
    }
}

protocol DailyChallenge {
    var data: [String] { get }
    
    func partOne() -> Void
    func partTwo() -> Void
}

public struct DailyChallengeSetup {
    let data: [String]
    
    public init(filename: String) {
        self.data = Utils.readFile(resourceName: filename)
    }
}
