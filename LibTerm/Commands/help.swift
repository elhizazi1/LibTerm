//
//  help.swift
//  LibTerm
//
//  Created by Adrian Labbe on 9/30/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import Foundation
import ObjectUserDefaults
#if !targetEnvironment(simulator)
import ios_system
#endif

/// The last login date.
let lastLogin = ObjectUserDefaults.standard.item(forKey: "lastLogin")

/// The `help` command.
func helpMain(argc: Int, argv: [String], io: LTIO) -> Int32 {
    
    var helpText: String
    
    #if FRAMEWORK
    helpText = ""
    #else
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        helpText = "LibTerm version \(version) (\(build)), \(formatter.string(from: BuildDate))\n\n"
    } else {
        helpText = "Unknown version\n\n"
    }
    #endif
    
    if argv.contains("--startup") || argv.contains("-s") {
        if let lastLogin = lastLogin.value as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            helpText = helpText.replacingOccurrences(of: "\n", with: "")
            helpText += "\nLast login: \(formatter.string(from: lastLogin))\n"
        }
        fputs(helpText, io.stdout)
        return 0
    }
    
    for command in LTHelp {
        if command != LTHelp.last {
            helpText += "\(command.commandName), "
        } else {
            helpText += "\(command.commandName)\n"
        }
    }
    
    helpText += "\nUse the 'package' command to install third party commands.\n"
    fputs(helpText, io.stdout)
    
    return 0
}
