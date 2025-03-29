<div align="center">
  <img src="/astra/Assets.xcassets/astra.imageset/astra.png" alt="Astra Logo">
  <div style="width: 50%; margin: 0 auto;">
    <h3>Astra <br> Your command center in the stars ⭐️</h3>
  </div>
</div>

Astra is a powerful, lightweight macOS menu bar application that provides quick access to your frequently used terminal commands directly from the menu bar. With Astra, you can organize, execute, and log terminal commands with ease, saving time and boosting productivity.

## Features

- **Quick Command Access**: Execute terminal commands with a single click from your menu bar
- **Command Organization**: Group related commands into categories for better organization
- **Custom Shell Support**: Use your preferred shell (zsh, bash, fish, etc.)
- **Shell RC Integration**: Automatically sources your shell RC file before executing commands
- **Command Logging**: Comprehensive logging of command outputs and application actions
- **User-Friendly UI**: Clean, intuitive macOS-native SwiftUI interface

## Installation

1. Download the latest release from the [Releases](https://github.com/yourusername/astra/releases) page
2. Move the Astra app to your Applications folder
3. Launch Astra
4. (Optional) Configure Astra to start at login in System Preferences

## Configuration

Astra stores its configuration in a JSON file located at `~/.config/astra/astra_commands.json`. This file is created automatically with default settings when you first run the application.

### Configuration Structure

The configuration file follows this structure:

```json
{
  "astraName": "Bankai!",
  "shellPath": "/bin/zsh",
  "shellRcPath": "~/.zshrc",
  "commandGroups": [
    {
      "name": "Network Tools",
      "icon": "network",
      "commands": [
        {
          "name": "Copy IP Address",
          "icon": "wifi",
          "command": "ipconfig getifaddr en0 | pbcopy"
        }
      ]
    }
  ],
  "standaloneCommands": [
    {
      "name": "Edit Astra Commands",
      "icon": "apple.terminal",
      "command": "code ~/.config/astra/astra_commands.json"
    }
  ]
}
```

### Adding Commands

You can add commands to Astra in two ways:

#### Method 1: Edit the Configuration File Directly

1. Click on "Edit Astra Commands" in the Astra menu (a default command)
2. Add your commands to the appropriate section:
   - Add standalone commands to the `standaloneCommands` array
   - Add command groups to the `commandGroups` array
   - Add commands within a group to that group's `commands` array
3. Save the file
4. In Astra, go to Settings > Reload Config to apply your changes

#### Method 2: Programmatically Using the Configuration Structure

Each command requires the following properties:
- `name`: The display name for the command in the menu
- `icon`: An SF Symbol name for the icon (see [SF Symbols](https://developer.apple.com/sf-symbols/))
- `command`: The terminal command to execute

### Example Commands

Here are some example commands with visual outputs and practical applications:

#### Standalone Commands

```json
"standaloneCommands": [
  {
    "name": "Open System Settings",
    "icon": "gear",
    "command": "open 'x-apple.systempreferences:'"
  },
  {
    "name": "View Network Info",
    "icon": "network",
    "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"ifconfig; wait; exit\"'"
  },
  {
    "name": "Show Calendar",
    "icon": "calendar",
    "command": "open -a Calendar"
  },
  {
    "name": "Take Screenshot",
    "icon": "camera",
    "command": "screencapture -i ~/Desktop/screenshot-$(date +%Y%m%d-%H%M%S).png"
  },
  {
    "name": "Weather",
    "icon": "cloud.sun",
    "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"curl wttr.in; wait; exit\"'"
  }
]
```

#### Development Workflow Example

```json
"commandGroups": [
  {
    "name": "Backend Projects",
    "icon": "server.rack",
    "commands": [
      {
        "name": "Open API Project",
        "icon": "network",
        "command": "code ~/projects/backend/api-service"
      },
      {
        "name": "Start API Server",
        "icon": "play.fill",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"cd ~/projects/backend/api-service && npm start\"'"
      },
      {
        "name": "Run API Tests",
        "icon": "checkmark.circle",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"cd ~/projects/backend/api-service && npm test\"'"
      }
    ]
  },
  {
    "name": "Frontend Projects",
    "icon": "macwindow",
    "commands": [
      {
        "name": "Open Web Client",
        "icon": "globe",
        "command": "code ~/projects/frontend/web-client"
      },
      {
        "name": "Start Dev Server",
        "icon": "play.fill",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"cd ~/projects/frontend/web-client && npm run dev\"'"
      },
      {
        "name": "Open in Browser",
        "icon": "safari",
        "command": "open http://localhost:3000"
      }
    ]
  }
]
```

#### DevOps Tools

```json
"commandGroups": [
  {
    "name": "Docker Tools",
    "icon": "cube.box",
    "commands": [
      {
        "name": "Container Dashboard",
        "icon": "gauge",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"docker stats\"'"
      },
      {
        "name": "Start Development Stack",
        "icon": "play.fill",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"cd ~/projects/docker && docker-compose up -d\"'"
      },
      {
        "name": "Stop All Containers",
        "icon": "stop.fill",
        "command": "docker stop $(docker ps -q)"
      }
    ]
  },
  {
    "name": "AWS Tools",
    "icon": "cloud",
    "commands": [
      {
        "name": "List EC2 Instances",
        "icon": "server.rack",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"aws ec2 describe-instances --query Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType] --output table\"'"
      },
      {
        "name": "View S3 Buckets",
        "icon": "externaldrive",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"aws s3 ls\"'"
      }
    ]
  }
]
```

#### System Monitoring and Utilities

```json
"commandGroups": [
  {
    "name": "System Monitor",
    "icon": "gauge",
    "commands": [
      {
        "name": "Show CPU Usage",
        "icon": "cpu",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"top -o cpu; exit\"'"
      },
      {
        "name": "Memory Usage",
        "icon": "memorychip",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"vm_stat; exit\"'"
      },
      {
        "name": "Disk Space",
        "icon": "internaldrive",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"df -h; exit\"'"
      }
    ]
  },
  {
    "name": "Network Tools",
    "icon": "network",
    "commands": [
      {
        "name": "WiFi Scan",
        "icon": "wifi",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s; exit\"'"
      },
      {
        "name": "Open Network Utility",
        "icon": "dial.min",
        "command": "open /System/Library/CoreServices/Applications/Network\\ Utility.app"
      },
      {
        "name": "Ping Google",
        "icon": "arrow.triangle.2.circlepath",
        "command": "open -a Terminal.app && osascript -e 'tell application \"Terminal\" to do script \"ping -c 5 google.com; exit\"'"
      }
    ]
  }
]
```

## Settings

Astra provides several settings that can be configured through the menu:

- **Shell Selection**: Choose between bash, zsh, or fish
- **Config Management**: Open the config folder or reload the configuration
- **Logs Access**: View command execution logs for debugging or reference

## Logs

Astra keeps detailed logs of command executions and configuration changes in `~/.config/astra/logs/`. These logs are useful for:

- Debugging command issues
- Reviewing command outputs
- Tracking configuration changes

You can access the logs directory by clicking "Open Logs Folder" in the Settings menu.

## Tips and Tricks

1. **SF Symbols**: Astra uses SF Symbols for icons. Browse available symbols at [SF Symbols](https://developer.apple.com/sf-symbols/) to customize your command icons.

2. **Complex Commands**: For complex commands with multiple steps, consider using a shell script and executing that script from Astra.

3. **Command Groups**: Organize related commands into groups for a cleaner menu. For example, create groups for "Development", "System", "Network", etc.

4. **Clipboard Integration**: Commands can use `pbcopy` and `pbpaste` to interact with the clipboard.

5. **Dynamic Commands**: You can use command substitution and environment variables in your commands, as they're executed in a full shell environment.

6. **Application Integration**: Use the `open` command to launch applications or URLs, creating a comprehensive launcher for your workflow.

7. **Terminal Visualization**: For commands that produce visual output, use the Terminal.app with AppleScript to display the results.

## Troubleshooting

- **Command Not Executing**: Ensure the command works directly in Terminal. Check the logs for error messages.
- **Configuration Not Loading**: Verify your JSON is valid. Use a JSON validator if needed.
- **Shell Issues**: Make sure the shell path in your config is correct and the shell is installed.

## License

[MIT License](LICENSE)

## Acknowledgments

- Created by Miten Gajjar
- Built with SwiftUI for macOS
- Uses SF Symbols for iconography 