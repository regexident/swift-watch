// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import CommandCougar

struct Configuration {
    let clear: Bool
    let dryRun: Bool
    let quiet: Bool
    let postpone: Bool
    let monochrome: Bool

    let tasks: [Task]
    let directoryURL: URL

    static let clearOption = Option(
        flag: .both(short: "c", long: "clear"),
        overview: "Clear output before each execution"
    )
    static let dryRunOption = Option(
        flag: .both(short: "d", long: "dry-run"),
        overview: "Do not run any commands, just print them"
    )
    static let quietOption = Option(
        flag: .both(short: "q", long: "quiet"),
        overview: "Suppress output from swift-watch itself"
    )
    static let postponeOption = Option(
        flag: .both(short: "p", long: "postpone"),
        overview: "Postpone initial execution until the first change"
    )
    static let monochromeOption = Option(
        flag: .both(short: "m", long: "monochrome"),
        overview: "Suppress coloring of output from swift-watch itself"
    )
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
    init(evaluation: CommandEvaluation, directoryURL: URL) throws {
        let options = evaluation.options

        let clear = options.contains { $0.flag == Configuration.clearOption.flag }
        let dryRun = options.contains { $0.flag == Configuration.dryRunOption.flag }
        let quiet = options.contains { $0.flag == Configuration.quietOption.flag }
        let postpone = options.contains { $0.flag == Configuration.postponeOption.flag }
        let monochrome = options.contains { $0.flag == Configuration.monochromeOption.flag }
        let tasks: [Task] = options.flatMap {
            guard case let (flag, parameter?) = ($0.flag, $0.parameter) else {
                return nil
            }
            switch flag {
            case Configuration.swiftOption.flag:
                return .swift(parameter)
            case Configuration.shellOption.flag:
                return .shell(parameter)
            case _:
                return nil
            }
        }
        self.init(
            clear: clear,
            dryRun: dryRun,
            quiet: quiet,
            postpone: postpone,
            monochrome: monochrome,
            tasks: tasks,
            directoryURL: directoryURL
        )
    }
}
