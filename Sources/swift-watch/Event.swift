// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

struct TaskError: Swift.Error, CustomStringConvertible {
    let statusCode: Int32

    var description: String {
        return "Status code \(self.statusCode)"
    }
}

enum TaskResult {
    case success
    case failure(TaskError)

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure(_): return false
        }
    }
}

struct TaskSuite {
    let tasks: [Task]

    init(configuration: Configuration) {
        self.tasks = configuration.tasks
    }
}

struct TaskSuiteReport {
    typealias Result = TaskResult

    let reports: [TaskReport]
}

enum Task {
    case swift(String)
    case shell(String)

    var invocation: String {
        switch self {
        case .swift(let command): return "swift " + command
        case .shell(let command): return command
        }
    }
}

struct TaskReport {
    typealias Result = TaskResult

    let task: Task
    let result: Result
}

enum Event {
    case enteredTaskSuite(TaskSuite)
    case exitedTaskSuite(TaskSuiteReport)
    case enteredTask(Task)
    case exitedTask(TaskReport)
}
