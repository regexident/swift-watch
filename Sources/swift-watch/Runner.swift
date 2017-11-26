// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Rainbow

class Runner {
    struct Error: Swift.Error, CustomStringConvertible {
        let statusCode: Int32

        var description: String {
            return "Status code \(self.statusCode)"
        }
    }

    let directoryURL: URL
    let configuration: Configuration
    private let queue: DispatchQueue = .init(label: "swift-watch")
    private var running: Bool = false

    init(directoryURL: URL, configuration: Configuration) {
        self.directoryURL = directoryURL
        self.configuration = configuration
    }

    func run() throws {
        self.running = true
        defer { self.running = false }
        do {
            print("Running...\n")
            for command in self.configuration.swiftCommands {
                try self.run(command: "swift " + command)
                self.delay()
            }
            for command in self.configuration.shellCommands {
                try self.run(command: command)
                self.delay()
            }
            let result = "success".onGreen
            print("Finished running with \(result).".lightGreen)
        } catch {
            let result = "failure".onRed
            print("Finished running with \(result).".lightRed)
        }
    }

    private func run(command: String) throws {
        var statusCode: Int32 = 0
        print("Running program: $ \(command.onBlue).\n".lightBlue)
        self.queue.sync {
            if self.configuration.dryRun {
                statusCode = 0
            } else {
                statusCode = Process.execute(command: command)
            }
        }
        print("Program ended with success.\n".lightGreen)
        guard statusCode == 0 else {
            let error = Error(statusCode: statusCode)
            print("Program ended with error: \(error.description.onRed).\n".lightRed)
            throw error
        }
    }

    private func delay() {
        sleep(1)
    }
}
