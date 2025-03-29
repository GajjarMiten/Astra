//
//  Board.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//

import SwiftUI

struct Board: View {
    @ObservedObject var configController: ConfigController
    @ObservedObject var commandExecutor: CommandExecutor

    var body: some View {
        @State var config = configController.config
        @State var executables = configController.config.toExecutableList()

        ForEach(executables, id: \.id) { executable in
            if let group = executable as? CommandGroup {
                Menu {
                    ForEach(group.commands) { command in
                        ExecutableMenuItemView(
                            executable: command,
                            commandExecutor: commandExecutor)
                    }
                } label: {
                    HStack(alignment: .bottom) {
                        Image(systemName: group.icon)
                        Spacer()
                        Text(group.name)
                    }
                }
            } else if let command = executable as? Command {
                ExecutableMenuItemView(
                    executable: command,
                    commandExecutor: commandExecutor
                )
            }
        }

        Divider()

        Menu("Settings") {
            // Show current shell
            Text("Current shell: \(configController.config.shellPath)")

            // Shell selection options
            Button("Use /bin/bash") {
                configController.updateShellPath("/bin/bash")
            }
            Button("Use /bin/zsh") {
                configController.updateShellPath("/bin/zsh")
            }
            Button("Use /opt/homebrew/bin/fish") {
                configController.updateShellPath("/opt/homebrew/bin/fish")
            }

            Divider()

            // Open config file location
            Button("Open Config Folder") {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
                process.arguments = [
                    FileManager.default.homeDirectoryForCurrentUser
                        .appendingPathComponent(configController.configDirName)
                        .path
                ]
                try? process.run()
            }
            
            // Open logs directory
            Button("Open Logs Folder") {
                configController.openLogsDirectory()
            }

            // Reload config option
            Button("Reload Config") {
                configController.loadConfig()
            }
        }

        Divider()

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}

struct ExecutableMenuItemView: View {
    let executable: any Executable
    @ObservedObject var commandExecutor: CommandExecutor

    var body: some View {
        Button {
            commandExecutor.executeCommand(executable: executable)
        } label: {
            HStack(alignment: .bottom) {
                Image(systemName: executable.icon)
                Spacer()
                Text(executable.name)
            }
        }
    }
}
