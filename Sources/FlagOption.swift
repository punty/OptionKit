//
//  FlagOption.swift
//  OptionKit
//
//  Created by Francesco Puntillo on 23/09/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

public struct FlagOption: Hashable {
    var shortFlag: String?
    var flag: String
    var helpMessage:String
    var value: String?
    var required: Bool
    var takesArguments: Bool
    
    public init(shortFlag: String, flag: String, helpMessage: String, required: Bool, takesArguments: Bool) {
        value = nil
        self.takesArguments = takesArguments
        self.required = required
        self.flag = flag
        self.shortFlag = shortFlag
        self.helpMessage = helpMessage
    }
    
    public var hashValue: Int {
        return flag.hashValue
    }
    
    public static func ==(lhs: FlagOption, rhs: FlagOption) -> Bool {
        return lhs.flag == rhs.flag
    }
}
