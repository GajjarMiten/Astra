//
//  AstraApp.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//

import SwiftUI

@main
struct AstraApp: App {
    @StateObject private var configController = ConfigController()
    @StateObject private var commandExecutor: CommandExecutor
    @State private var iconIndex = 0
    let icons = ["figure.run.treadmill", "figure.walk.treadmill"]
    
    init() {
        let configControllerInstance = ConfigController()
        _configController = StateObject(wrappedValue: configControllerInstance)
        _commandExecutor = StateObject(wrappedValue: CommandExecutor(configController: configControllerInstance))
    }
    
    var body: some Scene {
        MenuBarExtra {
            Board(configController: configController, commandExecutor: commandExecutor)
        } label: {
            HStack(alignment: .bottom) {
                Image(systemName: icons[iconIndex])
                    .onAppear {
                        Timer.scheduledTimer(
                            withTimeInterval: 0.5, repeats: true
                        ) { _ in
                            iconIndex = (iconIndex + 1) % icons.count
                        }
                    }
                Spacer()
                Text(configController.config.astraName)
            }
        }
    }
}
