import XCTest
@testable import OptionKit

class OptionKitTests: XCTestCase {
    func testSingleOptionParse() {
        let flags = [FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: true, takesArguments: false)]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "-h"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 1)
        XCTAssert(res.extraArgs.count == 0)
    }
    
    func testConcatOptionParse() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "-hv"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        XCTAssert(res.extraArgs.count == 0)
    }
    
    func testConcatLastArgOptionParse() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: true)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "-hv", "arg1"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        for flag in res.options {
            if flag.flag == "vesion" {
                XCTAssert(flag.value == "arg1")
            }
            if flag.flag == "help" {
                XCTAssert(flag.value == nil)
            }
        }
        XCTAssert(res.extraArgs.count == 0)
    }
   
    
    func testConcatLastNoArgOptionParse() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "-hv", "arg1"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        for flag in res.options {
            if flag.flag == "vesion" {
                XCTAssert(flag.value == nil)
            }
            if flag.flag == "help" {
                XCTAssert(flag.value == nil)
            }
        }
        XCTAssert(res.extraArgs.count == 1)
        XCTAssert(res.extraArgs[0] == "arg1")
        
    }
    
    func testLongFlag() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "--help", "--version"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        for flag in res.options {
            if flag.flag == "vesion" {
                XCTAssert(flag.value == nil)
            }
            if flag.flag == "help" {
                XCTAssert(flag.value == nil)
            }
        }
        XCTAssert(res.extraArgs.count == 0)
    }
    
    func testAttachedValue() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: true)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: true)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "--help=aiuto", "--version=versione"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        for flag in res.options {
            if flag.flag == "vesion" {
                XCTAssert(flag.value == "versione")
            }
            if flag.flag == "help" {
                XCTAssert(flag.value == "aiuto")
            }
        }
        XCTAssert(res.extraArgs.count == 0)
    }
    
    func testAttachedValueExtraArgs() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: true)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: true)
        
        let flags = [
            helpFlag,
            versFlag
            
        ]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "--help=aiuto", "--version=versione", "arg1", "arg2"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 2)
        XCTAssert(res.options.index(of: helpFlag) != nil)
        XCTAssert(res.options.index(of: versFlag) != nil)
        for flag in res.options {
            if flag.flag == "vesion" {
                XCTAssert(flag.value == "versione")
            }
            if flag.flag == "help" {
                XCTAssert(flag.value == "aiuto")
            }
        }
        XCTAssert(res.extraArgs.count == 2)
        XCTAssert(res.extraArgs[0] == "arg1")
        XCTAssert(res.extraArgs[1] == "arg2")
    }
    
    
    static var allTests : [(String, (OptionKitTests) -> () throws -> Void)] {
        return [
            ("testSingleOptionParse", testSingleOptionParse),
            ("testConcatOptionParse", testConcatOptionParse),
            ("testConcatLastArgOptionParse", testConcatLastArgOptionParse),
            ("testConcatLastNoArgOptionParse", testConcatLastNoArgOptionParse),
            ("testLongFlag", testLongFlag),
            ("testAttachedValue", testAttachedValue),
            ("testAttachedValueExtraArgs", testAttachedValueExtraArgs),
        ]
    }
 
}
