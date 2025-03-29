//
//  CommandExecutor.swift
//  astra
//
//  Created by Miten Gajjar on 29/03/25.
//

import Foundation

class CommandExecutor: ObservableObject {
    private let configController: ConfigController

    init(configController: ConfigController) {
        self.configController = configController
    }

    func executeCommand(executable: any Executable) {
        // Since command groups are just containers in the UI and not directly executable,
        // we only need to handle Command objects
        if let command = executable as? Command {
            executeSingleCommand(command)
        }
    }

    private func executeSingleCommand(_ command: Command) {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe

        // Include shell rc file if it exists
        let shellRcPath = configController.config.shellRcPath
            .replacingOccurrences(
                of: "~",
                with: FileManager.default.homeDirectoryForCurrentUser.path)

        // Create a command that sources the RC file if it exists and then executes the command
        let fullCommand = "source \(shellRcPath) && \(command.command)"
        //            "if [ -f \"\(shellRcPath)\" ]; then source \"\(shellRcPath)\"; fi; \(command.command)"

        process.arguments = ["-c", fullCommand]
        process.executableURL = URL(
            fileURLWithPath: configController.config.shellPath)

        do {
            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                let message =
                    "Command output for '\(command.name)':\n\(output)"
                configController.logger.log(message)
            }
        } catch {
            let errorMessage =
                "Error executing '\(command.name)': \(error.localizedDescription)"

            // Log the error
            configController.logger.log(errorMessage, level: .error)

        }
    }
}
