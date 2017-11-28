// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class Logger {
    let configuration: Configuration

    fileprivate var colored: Bool {
        return !self.configuration.monochrome
    }

    fileprivate var quiet: Bool {
        return self.configuration.quiet
    }

    fileprivate var prefix: String {
        return "swift-watch: "
    }

    required init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension Logger: RunnerObserver {
    func observe(event: Event) {
        switch event {
        case .enteredTaskSuite(let taskSuite):
            self.entered(taskStuite: taskSuite)
        case .exitedTaskSuite(let report):
            self.exited(taskStuite: report)
        case .enteredTask(let task):
            self.entered(task: task)
        case .exitedTask(let report):
            self.exited(task: report)
        }
    }
}

extension Logger {
    private func entered(taskStuite: TaskSuite) {
        guard !self.quiet else {
            return // quiet mode
        }
        print("\n" + self.prefix, terminator: "")
        let messageString = "Entering tasks...\n"
        let styledMessageString = self.colored ? messageString.lightBlue : messageString
        print(styledMessageString)
    }

    private func exited(taskStuite report: TaskSuiteReport) {
        guard !self.quiet else {
            return // quiet mode
        }
        print(self.prefix, terminator: "")
        let taskCount = report.reports.count
        let failure = report.reports.first { !$0.result.isSuccess }.map { $0.result }
        switch failure {
        case .some(.success), .none:
            let successString = "success"
            let messageString = "Exited \(taskCount) tasks with \(successString).\n"
            let styledMessageString = self.colored ? messageString.lightGreen : messageString
            print(styledMessageString)
        case .some(.failure(let error)):
            let failureString = error.description
            let messageString = "Exited \(taskCount) tasks with error: \(failureString).\n"
            let styledMessageString = self.colored ? messageString.lightRed : messageString
            print(styledMessageString)
        }
    }

    private func entered(task: Task) {
        guard !self.quiet else {
            return // quiet mode
        }
        print(self.prefix, terminator: "")
        let commandString = task.invocation
        let messageString = "Entering task: $ \(commandString).\n"
        let styledMessageString = self.colored ? messageString.lightBlue : messageString
        print(styledMessageString)
    }

    private func exited(task report: TaskReport) {
        guard !self.quiet else {
            return // quiet mode
        }
        print("\n" + self.prefix, terminator: "")
        switch report.result {
        case .success:
            let messageString = "Exited task with success.\n"
            let styledMessageString = self.colored ? messageString.lightGreen : messageString
            print(styledMessageString)
        case .failure(let error):
            let failureString = error.description
            let messageString = "Exited task with error: \(failureString).\n"
            let styledMessageString = self.colored ? messageString.lightRed : messageString
            print(styledMessageString)
        }
    }
}
