// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import CommandCougar

var watchCommand = Command(
    name: "swift-watch",
    overview: """
Watches over your Swift project's source

Tasks (-x & -s) are executed in the order they appear.
""",
    callback: nil,
    options: [
        Configuration.clearOption,
        Configuration.dryRunOption,
        Configuration.quietOption,
        Configuration.monochromeOption,
        Configuration.swiftOption,
        Configuration.shellOption,
    ],
    parameters: []
)

let configuration: Configuration

do {
    let arguments = CommandLine.arguments
    let evaluation = try watchCommand.evaluate(arguments: arguments)
    configuration = try Configuration(evaluation: evaluation)
} catch {
    print("ERROR: \(error)")
    print()
    print(watchCommand.help())
    exit(0)
}

let directoryPath: String = FileManager.default.currentDirectoryPath
let directoryURL: URL = URL(fileURLWithPath: directoryPath)

let observers: [RunnerObserver] = [
    Logger(configuration: configuration)
]

let loop = MainLoop(
    directoryURL: directoryURL,
    configuration: configuration,
    observers: observers
)

do {
    try loop.start()
} catch let error {
    print("ERROR: \(error)")
}
