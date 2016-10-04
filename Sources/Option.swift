
import Foundation

public struct Option: Hashable {
    public let shortName: String?
    public let name: String
    public let helpMessage:String
    public var value: String?
    public let required: Bool
    public let takesArguments: Bool
    
    public init(shortName: String?, name: String, helpMessage: String, required: Bool, takesArguments: Bool) {
        value = nil
        self.takesArguments = takesArguments
        self.required = required
        self.name = name
        self.shortName = shortName
        self.helpMessage = helpMessage
    }
    
    public var hashValue: Int {
        return name.hashValue
    }
    
    public static func ==(lhs: Option, rhs: Option) -> Bool {
        return lhs.name == rhs.name
    }
    
    func usage() -> String {
        let shortUsage = shortName != nil ? "-\(shortName!), " : ""
        let usage = shortUsage + "--\(name):"
        return "\(usage) \n \t \(helpMessage) (\(required ? "Required" : "Optional")) \n"
    }
    
}
