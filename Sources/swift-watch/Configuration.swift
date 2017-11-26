// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import CommandCougar

struct Configuration {
    let swiftCommands: [String]
    let shellCommands: [String]

    static let swiftOption = Option(
        flag: .both(short: "x", long: "exec"),
        overview: "Swift command(s) to execute on changes",
        parameterName: "<cmd>"
    )
    static let shellOption = Option(
        flag: .both(short: "s", long: "shell"),
        overview: "Shell command(s) to execute on changes",
        parameterName: "<cmd>"
    )
}

extension Configuration {
    init(evaluation: CommandEvaluation) throws {
        let options = evaluation.options

        let swiftCommands = options.filter { $0.flag == Configuration.swiftOption.flag }.flatMap { $0.parameter }
        let shellCommands = options.filter { $0.flag == Configuration.shellOption.flag }.flatMap { $0.parameter }

        self.init(
            swiftCommands: swiftCommands,
            shellCommands: shellCommands
        )
    }
}
