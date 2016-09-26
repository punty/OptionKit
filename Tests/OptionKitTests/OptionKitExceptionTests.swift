//
//  OptionKitExceptionTests.swift
//  OptionKit
//
//  Created by Francesco Puntillo on 26/09/2016.
//
//

import XCTest
@testable import OptionKit

class OptionKitExceptionTests: XCTestCase {
    func testMissingFlag() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: true, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: true, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
        ]
        let parser = OptionParser(flags: flags)
        do  {
           let _ = try parser.parse(arguments: ["test"])
        } catch let error as OptionKitError {
            switch error {
            case .requiredOptionMissing(let flags):
                XCTAssert(flags == "help version", "Wrong flags in required argument exception")
                return
            default:
                XCTFail("Wrong Exception Type, Expecting: requiredOptionMissing")
                return
            }
        } catch {
            XCTFail("Not the right exception")
            return
        }
        
        XCTFail("No exception throws")
    }
    
    func testMissingArgument() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: true, takesArguments: true)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: true, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
        ]
        let parser = OptionParser(flags: flags)
        do  {
            let _ = try parser.parse(arguments: ["test", "-hv"])
        } catch let error as OptionKitError {
            switch error {
            case .requiredArgumentMissing(let flags):
                XCTAssert(flags == "help", "Wrong flags in required argument exception")
                return
            default:
                XCTFail("Wrong Exception Type, Expecting: requiredArgumentMissing")
                return
            }
        } catch {
            XCTFail("Not the right exception")
            return
        }
        
        XCTFail("No exception throws")
    }
    
    func testExtraArgument() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: true, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: true, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
        ]
        let parser = OptionParser(flags: flags)
        do  {
            let _ = try parser.parse(arguments: ["test", "-h", "aiuto", "-v"])
        } catch let error as OptionKitError {
            switch error {
            case .unexpectedArgument(let flags):
                XCTAssert(flags == "aiuto", "unexpected argument")
                return
            default:
                XCTFail("Wrong Exception Type, Expecting: unexpectedArgument")
                return
            }
        } catch {
            XCTFail("Not the right exception")
            return
        }
        
        XCTFail("No exception throws")
    }
    
    func testNotValidOptionEnd() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
        ]
        let parser = OptionParser(flags: flags)
        do  {
            let _ = try parser.parse(arguments: ["test", "-hdv"])
        } catch let error as OptionKitError {
            switch error {
            case .optionNotValid(let flags):
                XCTAssert(flags == "d", "unexpected option")
                return
            default:
                XCTFail("Wrong Exception Type, Expecting: optionNotValid")
                return
            }
        } catch {
            XCTFail("Not the right exception")
            return
        }
        
        XCTFail("No exception throws")
    }
    
    func testExtraArgumentEnd() {
        let helpFlag = FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: false, takesArguments: false)
        let versFlag = FlagOption(shortFlag: "v", flag: "version", helpMessage: "Print Version", required: false, takesArguments: false)
        
        let flags = [
            helpFlag,
            versFlag
        ]
        let parser = OptionParser(flags: flags)
        do  {
            let res = try parser.parse(arguments: ["test", "-hv", "aiuto", "versione"])
            XCTAssert(res.options.count == 2, "we should have 2 options")
            XCTAssert(res.extraArgs.count == 2, "Extra Args should contain 2 values")
            XCTAssert(res.extraArgs[0] == "aiuto", "First extra argument is aiuto")
            XCTAssert(res.extraArgs[1] == "versione", "Secong extra argument is versione")
        } catch {
            XCTFail("Shouldnt throws excpetion")
        }
    }
    
    
    
    static var allTests : [(String, (OptionKitExceptionTests) -> () throws -> Void)] {
        return [
            ("testMissingFlag", testMissingFlag),
            ("testMissingArgument", testMissingArgument),
            ("testExtraArgument", testExtraArgument),
            ("testExtraArgumentEnd", testExtraArgumentEnd),
        ]
    }
}
