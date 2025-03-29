//
//  ConfigController.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//
import Foundation

class ConfigController: ObservableObject {
    @Published var config: Config
    private let configFileName = "astra_commands.json"
    private let defaultShell = "/bin/zsh"
    private let defaultShellRcPath = "~/.zshrc"
    private let defaultAstraName = "Bankai!"
    let configDirName = ".config/astra"
    let logsDirName = "logs"

    private var logsDirURL: URL {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let configDir = homeDirectory.appendingPathComponent(configDirName)
        return configDir.appendingPathComponent(logsDirName)
    }

    private(set) var logger: Logger!

    private var configFileURL: URL {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let configDir = homeDirectory.appendingPathComponent(configDirName)

        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: configDir.path) {
            try? FileManager.default.createDirectory(
                at: configDir, withIntermediateDirectories: true)
        }

        return configDir.appendingPathComponent(configFileName)
    }

    init() {
        // Set default config in case loading fails
        self.config = Config(
            astraName: defaultAstraName,
            shellPath: defaultShell,
            shellRcPath: defaultShellRcPath,
            commandGroups: [
                CommandGroup(
                    name: "Network Tools",
                    icon: "network",
                    commands: [
                        Command(
                            name: "Copy IP Address", icon: "wifi",
                            command: "ipconfig getifaddr en0 | pbcopy"),
                        Command(
                            name: "View Network Info", icon: "network",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"ifconfig; wait; exit\"'"),
                        Command(
                            name: "Ping Google", icon: "arrow.triangle.2.circlepath",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"ping -c 5 google.com; exit\"'")
                    ]
                ),
                CommandGroup(
                    name: "System Tools",
                    icon: "gear",
                    commands: [
                        Command(
                            name: "Show CPU Usage", icon: "cpu",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"top -o cpu; exit\"'"),
                        Command(
                            name: "Disk Space", icon: "internaldrive",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"df -h; exit\"'"),
                        Command(
                            name: "Memory Usage", icon: "memorychip",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"vm_stat; exit\"'")
                    ]
                ),
                CommandGroup(
                    name: "Development Tools",
                    icon: "terminal",
                    commands: [
                        Command(
                            name: "Open Projects Folder", icon: "folder",
                            command: "open ~/projects"),
                        Command(
                            name: "List Git Branches", icon: "arrow.triangle.branch",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"git branch -a; exit\"'"),
                        Command(
                            name: "Git Status", icon: "info.circle",
                            command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"git status; exit\"'")
                    ]
                )
            ],
            standaloneCommands: [
                Command(
                    name: "Edit Astra Commands", icon: "apple.terminal",
                    command: "code ~/.config/astra/astra_commands.json"),
                Command(
                    name: "Open System Settings", icon: "gear",
                    command: "open 'x-apple.systempreferences:'"),
                Command(
                    name: "Weather", icon: "cloud.sun",
                    command: "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"curl wttr.in; wait; exit\"'"),
                Command(
                    name: "Take Screenshot", icon: "camera",
                    command: "screencapture -i ~/Desktop/screenshot-$(date +%Y%m%d-%H%M%S).png")
            ]
        )

        // Initialize logger
        self.logger = Logger(logsDirURL: logsDirURL)

        loadConfig()
    }

    func loadConfig() {
        if FileManager.default.fileExists(atPath: configFileURL.path) {
            do {
                let data = try Data(contentsOf: configFileURL)
                let decoder = JSONDecoder()
                self.config = try decoder.decode(Config.self, from: data)
                let successMessage =
                    "Configuration loaded successfully from: \(configFileURL.path)\nUsing shell: \(config.shellPath)"
                logger.log(successMessage)
            } catch {
                let errorMessage =
                    "Error loading configuration: \(error.localizedDescription)"

                // Log error in config loading
                logger.log(errorMessage, level: .error)

                createDefaultConfigFile()
            }
        } else {
            let message =
                "Configuration file not found. Creating default configuration."

            // Log config file not found
            logger.log(message, level: .error)

            createDefaultConfigFile()
        }
    }

    func saveConfig() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(config)
            try data.write(to: configFileURL)
            let successMessage =
                "Configuration saved successfully to: \(configFileURL.path)"
            // Log successful config saving
            logger.log(successMessage)
        } catch {
            let errorMessage =
                "Error saving configuration: \(error.localizedDescription)"

            // Log error in config saving
            logger.log(errorMessage, level: .error)
        }
    }

    private func createDefaultConfigFile() {
        saveConfig()
    }

    // Add a new standalone command
    func addCommand(_ command: Command) {
        config.standaloneCommands.append(command)

        // Log command addition
        let logMessage =
            "Added standalone command: \(command.name) with command: \(command.command)"
        logger.log(logMessage)

        saveConfig()
    }

    // Add a new command group
    func addCommandGroup(_ group: CommandGroup) {
        config.commandGroups.append(group)

        // Log command group addition
        var logMessage = "Added command group: \(group.name) with commands:"
        for command in group.commands {
            logMessage += "\n- \(command.name): \(command.command)"
        }
        logger.log(logMessage)

        saveConfig()
    }

    func updateShellPath(_ path: String) {
        let oldPath = config.shellPath
        config.shellPath = path

        // Log shell path update
        let logMessage = "Updated shell path from \(oldPath) to \(path)"
        logger.log(logMessage)

        saveConfig()
    }

    // Open logs directory in Finder
    func openLogsDirectory() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        process.arguments = [logsDirURL.path]

        do {
            try process.run()
            let logMessage = "Opened logs directory: \(logsDirURL.path)"

            logger.log(logMessage)
        } catch {
            let errorMessage =
                "Failed to open logs directory: \(error.localizedDescription)"

            logger.log(errorMessage, level: .error)
        }
    }
}
