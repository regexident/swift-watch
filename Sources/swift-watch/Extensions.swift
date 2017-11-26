// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

extension Process {
    @discardableResult
    static func execute(command: String) -> Int32 {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        print("Command: \(command)\n")
        process.arguments = ["-S", command]
        process.launch()
        process.waitUntilExit()
        return process.terminationStatus
    }

    @discardableResult
    static func execute(command: [String]) -> Int32 {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        print("Command: '\(command)'\n")
        process.arguments = command
        process.launch()
        process.waitUntilExit()
        return process.terminationStatus
    }
}
