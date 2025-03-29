import Foundation

enum LogLevel: String {
    case info
    case error
}

// Logger class to handle logging operations
class Logger {
    private let logsDirURL: URL
    private let dateFormatter: DateFormatter

    init(logsDirURL: URL) {
        self.logsDirURL = logsDirURL
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"

        // Create logs directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: logsDirURL.path) {
            try? FileManager.default.createDirectory(
                at: logsDirURL, withIntermediateDirectories: true)
        }
    }

    func log(_ message: String, level: LogLevel = .info) {
        let timestamp = dateFormatter.string(from: Date())
        let logFileName =
            "\(timestamp)_\(level).log"
        let logFileURL = logsDirURL.appendingPathComponent(logFileName)
        print(message)

        do {
            var existingContent = ""
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                existingContent = try String(
                    contentsOf: logFileURL, encoding: .utf8)
            }
            let updatedContent = existingContent + "\n\n\(message)"
            try updatedContent.write(
                to: logFileURL, atomically: true, encoding: .utf8)

        } catch {

        }
    }

}
