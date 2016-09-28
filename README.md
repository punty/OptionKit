# OptionKit
Parser for Command Line Arguments in Swift

[![Build Status](https://travis-ci.org/punty/OptionKit.svg?branch=master)](https://travis-ci.org/punty/OptionKit)

Note: OptionKit `master` requires Xcode 8 / Swift 3.0

## Usage
```swift
let helpFlag = Option(shortName: "h", name: "help", helpMessage: "Print Help", required: false, takesArguments: false)
let versFlag = Option(shortName: "v", name: "version", helpMessage: "Print Version", required: false, takesArguments: false)
let fileFlag = Option(shortName: "f", name: "file", helpMessage: "set file", required: false, takesArguments: true)  
let flags = [helpFlag, versFlag, fileFlag]
let optionParser = OptionParser(flags: flags)

//get arguments from CommandLine
let args = CommandLine.arguments
do {
let result = try optionParser.parse(arguments:args)
//use the results
for flag in res.options {
print(flag.value)
}
//res.extraArgs will contain extra arguments

} catch {
//handle exception, maybe print usage
print(optionParser.usage())
}

```

