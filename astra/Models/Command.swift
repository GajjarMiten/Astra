//
//  Command.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//

import Foundation

class Command: Executable, Codable {
    let name: String
    let icon: String
    let command: String

    var id: String {
        name
    }

    init(name: String, icon: String, command: String) {
        self.name = name
        self.icon = icon
        self.command = command
    }
}

class CommandGroup: Executable, Codable {
    let name: String
    let icon: String
    let commands: [Command]
    
    var id: String {
        name
    }

    init(name: String, icon: String, commands: [Command]) {
        self.name = name
        self.icon = icon
        self.commands = commands
    }
}
