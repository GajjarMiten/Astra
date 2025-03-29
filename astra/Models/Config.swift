//
//  Config.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//
import Foundation

struct Config: Codable {
    var astraName: String
    var shellPath: String
    var shellRcPath: String
    var commandGroups: [CommandGroup]
    var standaloneCommands: [Command]
    
    // Convert to a flat list of Executable items
    func toExecutableList() -> [any Executable] {
        var result: [any Executable] = []
        result.append(contentsOf: commandGroups)
        result.append(contentsOf: standaloneCommands)
        return result
    }
}
