
import Foundation

public enum OptionKitError: Error {
    case optionNotValid(option: String)
    case unexpectedArgument(argument: String)
    case requiredOptionMissing(option: String)
    case requiredArgumentMissing(argument: String)
    
    func errorMessage() -> String {
        switch self {
        case .optionNotValid(let option):
            return "Invalid Option: '\(option)'"
        case .requiredArgumentMissing(let argument):
            return "Value is missing for the option: '\(argument)'"
        case .unexpectedArgument(let argument):
            return "Value '\(argument)' is not expected"
        case .requiredOptionMissing(let option):
            return "'\(option)' need a value"
        }
    }
}


public class OptionParser {
    
    private let shortFlagPrefix = "-"
    private let flagPrefix = "--"
    private let argumentAttacher = "="
    private let argumentStopper = "--"
    
     var skipOptions = false
    
    var flags: [Option]
    
    var name: String?
    
    public init(flags: [Option]) {
        self.flags = flags
    }
    
    public func usage() -> String {
        var message = ""
        if let name = self.name {
            message.append("Usage: \(name) [options] \n")
        }
        for opt in flags {
            message.append(opt.usage())
        }
        return message
    }
    
    //Find the option
    private func option(flag:String, short:Bool, flags:[Option]) throws -> Option {
        let index = flags.index() { flag == (short ? $0.shortName : $0.name)}
        guard let optionIndex = index else {throw OptionKitError.optionNotValid(option: flag)}
        return flags[optionIndex]
    }
    
    //Returns all argument values from flagIndex to the next flag or the end of the argument array
    private func flagValues(flagIndex: Int, arguments:[String], attachedArg: String? = nil) -> [String] {
        var args: [String] = []
        if let attachedArg = attachedArg {
            args.append(attachedArg)
        }
        let subArgs = arguments.dropFirst(flagIndex + 1)
       
        for element in subArgs {
            if element == argumentStopper {
                skipOptions = true
                continue
            }
            let first = element.substring(from: element.index(after: element.startIndex))
            if element.hasPrefix(shortFlagPrefix) && Int(first) == nil && !skipOptions  {
                break
            }
            args.append(element)
        }
        return args
    }
    
    
    public func parse(arguments: [String]) throws -> (options: [Option], extraArgs: [String]) {
        var resultOptions = [Option] ()
        skipOptions = false
        name = arguments[0]
        var externalArgs: [String] = []
        var skipElements = 1
        for (index, argument) in arguments.enumerated() {
            if skipOptions {
                break
            }
            if skipElements > 0 {
                skipElements -= 1
                continue
            }
            //handle --
            if argument.hasPrefix(flagPrefix) {
                let flagString = argument.substring(from: argument.index(argument.startIndex, offsetBy: 2))
                let argsumentSplit = flagString.characters.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true).map{String($0)}
                let attachedString: String? = (argsumentSplit.count == 2) ? argsumentSplit[1] : nil
                var flag = try option(flag: argsumentSplit[0], short: false, flags: flags)
                
                externalArgs = flagValues(flagIndex: index,  arguments: arguments, attachedArg: attachedString)
                if !externalArgs.isEmpty && !skipOptions {
                    if flag.takesArguments {
                        flag.value = externalArgs[0]
                        externalArgs = Array(externalArgs.dropFirst())
                    } else {
                        var argCount = externalArgs.count
                        //here we might get some extra arguments
                        if attachedString != nil {
                            argCount -= 1
                        }
                        if argCount < (arguments.count - index - 1) {
                            //it's not the last
                            throw OptionKitError.unexpectedArgument(argument: externalArgs.reduce("") {$0 + $1})
                        }
                    }
                }
                resultOptions.append(flag)
                skipElements = externalArgs.count
                if attachedString != nil {
                    skipElements -= 1
                }
            } else if argument.hasPrefix(shortFlagPrefix) {
                // Handle -
                let flagString = argument.substring(from: argument.index(after: argument.startIndex))
                let flagChars = flagString.characters.enumerated()
                for (charIndex, element) in flagChars {
                    var flag = try option(flag: String(element), short: true, flags: flags)
                    if charIndex == flagString.characters.count - 1 {
                        externalArgs = flagValues(flagIndex: index,  arguments: arguments)
                        if !externalArgs.isEmpty && !skipOptions {
                            if flag.takesArguments {
                                flag.value = externalArgs[0]
                                externalArgs = Array(externalArgs.dropFirst())
                            } else {
                                //here we might get some extra arguments
                                if externalArgs.count < (arguments.count - index - 1) {
                                    //it's not the last
                                    throw OptionKitError.unexpectedArgument(argument: externalArgs.reduce("") {$0 + $1})
                                }
                            }
                        }
                        skipElements = externalArgs.count
                    }
                    resultOptions.append(flag)
                }
            }
        }
        
        //validate the parsing
        let missingFlags = flags.filter{$0.required && !resultOptions.contains($0)}
        if missingFlags.count > 0 {
            let message = missingFlags.map{$0.name}.reduce("") {$0 + " " + $1}
            throw OptionKitError.requiredOptionMissing(option: message.substring(from: message.index(after: message.startIndex)))
        }
        
        let missingArgs = resultOptions.filter{$0.takesArguments && $0.value == nil}
        if missingArgs.count > 0 {
            let message = missingArgs.map{$0.name}.reduce("") {$0 + " " + $1}
            throw OptionKitError.requiredArgumentMissing(argument: message.substring(from: message.index(after: message.startIndex)))
        }
        
        return (resultOptions, externalArgs)
    }
    
}
