import XCTest
@testable import OptionKit

class OptionKitTests: XCTestCase {
    func testSingleOptionParse() {
        var flags = [FlagOption(shortFlag: "h", flag: "help", helpMessage: "Print Help", required: true, takesArguments: false)]
        let optionParser = OptionParser(flags: flags)
        let args = ["test", "-h"]
        let res = try! optionParser.parse(arguments:args)
        XCTAssert(res.options.count == 1)
        XCTAssert(res.extraArgs.count == 0)
    }
    
   
    static var allTests : [(String, (OptionKitTests) -> () throws -> Void)] {
        return [
            ("testSingleOptionParse", testSingleOptionParse),
        ]
    }
}
