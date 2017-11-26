// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class Logger {
    let configuration: Configuration

    fileprivate var colored: Bool {
        return !self.configuration.monochrome
    }

    fileprivate var silenced: Bool {
        return !self.configuration.quiet
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
        guard !self.silenced else {
            return // quiet mode
        }
        let messageString = "Entering tasks...\n"
        let styledMessageString = self.colored ? messageString.lightBlue : messageString
        print(styledMessageString)
    }

    private func exited(taskStuite report: TaskSuiteReport) {
        guard !self.silenced else {
            return // quiet mode
        }
        let taskCount = report.taskSuite.tasks.count
        switch report.result {
        case .success:
            let successString = "success"
            let styledSuccessString = self.colored ? successString.onGreen : successString
            let messageString = "Exited \(taskCount) tasks with \(styledSuccessString).\n"
            let styledMessageString = self.colored ? messageString.lightGreen : messageString
            print(styledMessageString)
        case .failure(let error):
            let failureString = error.description
            let styledFailureString = self.colored ? failureString.onRed : failureString
            let messageString = "Exited \(taskCount) tasks with error: \(styledFailureString).\n"
            let styledMessageString = self.colored ? messageString.lightRed : messageString
            print(styledMessageString)
        }
    }

    private func entered(task: Task) {
        guard !self.silenced else {
            return // quiet mode
        }
        let commandString = task.invocation
        let styledCommandString = self.colored ? commandString.onBlue : commandString
        let messageString = "Entering task: $ \(styledCommandString).\n"
        let styledMessageString = self.colored ? messageString.lightBlue : messageString
        print(styledMessageString)
    }

    private func exited(task report: TaskReport) {
        guard !self.silenced else {
            return // quiet mode
        }
        switch report.result {
        case .success:
            let messageString = "Exited task with success.\n"
            let styledMessageString = self.colored ? messageString.lightGreen : messageString
            print(styledMessageString)
        case .failure(let error):
            let failureString = error.description
            let styledFailureString = self.colored ? failureString.onRed : failureString
            let messageString = "Exited task with error: \(styledFailureString).\n"
            let styledMessageString = self.colored ? messageString.lightRed : messageString
            print(styledMessageString)
        }
    }
}
