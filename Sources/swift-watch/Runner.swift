// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class Runner {
    let directoryURL: URL
    let configuration: Configuration
    private let queue: DispatchQueue = .init(label: "swift-watch")
    private var running: Bool = false

    init(directoryURL: URL, configuration: Configuration) {
        self.directoryURL = directoryURL
        self.configuration = configuration
    }

    func run() {
        self.running = true
        defer { self.running = false }
        for command in self.configuration.swiftCommands {
            let command = "swift " + command
            print("Running program: $ \(command).\n")
            var statusCode: Int32 = 0
            self.queue.sync {
                if self.configuration.dryRun {
                    statusCode = 0
                } else {
                    statusCode = Process.execute(command: command)
                }
            }
            print("Program ended with exit code: \(statusCode)\n")
            guard statusCode == 0 else {
                return
            }
            self.delay()
        }
        for command in self.configuration.shellCommands {
            let command = command
            print("Running program: $ \(command).\n")
            var statusCode: Int32 = 0
            self.queue.sync {
                if self.configuration.dryRun {
                    statusCode = 0
                } else {
                    statusCode = Process.execute(command: command)
                }
            }
            print("Program ended with exit code: \(statusCode)\n")
            guard statusCode == 0 else {
                return
            }
            self.delay()
        }
    }

    private func delay() {
        sleep(1)
    }
}
