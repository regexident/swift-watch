// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Rainbow

class Runner {
    let directoryURL: URL
    let configuration: Configuration
    private let queue: DispatchQueue = .init(label: "swift-watch")
    private var running: Bool = false

    let observers: [RunnerObserver]

    init(directoryURL: URL, configuration: Configuration, observers: [RunnerObserver]) {
        self.directoryURL = directoryURL
        self.configuration = configuration
        self.observers = observers
    }

    func run(taskSuite: TaskSuite) -> TaskSuiteReport {
        self.running = true
        defer { self.running = false }
        var report = TaskSuiteReport(taskSuite: taskSuite, result: .success)
        self.broadcast(event: .enteredTaskSuite(taskSuite))
        for task in taskSuite.tasks {
            let taskResult = self.run(task: task).result
            if case .failure(_) = taskResult {
                report = TaskSuiteReport(taskSuite: taskSuite, result: taskResult)
                break
            }
            self.delay()
        }
        self.broadcast(event: .exitedTaskSuite(report))
        return report
    }

    private func run(task: Task) -> TaskReport {
        var statusCode: Int32 = 0
        self.broadcast(event: .enteredTask(task))
        self.queue.sync {
            if self.configuration.dryRun {
                statusCode = 0
            } else {
                let invocation = task.invocation
                statusCode = Process.execute(command: invocation)
            }
        }
        let result: TaskResult
        switch statusCode {
        case 0:
            result = .success
        case _:
            result = .failure(TaskError(statusCode: statusCode))
        }
        let report = TaskReport(task: task, result: result)
        self.broadcast(event: .exitedTask(report))
        return report
    }

    private func delay() {
        sleep(1)
    }

    private func broadcast(event: Event) {
        for observer in self.observers {
            observer.observe(event: event)
        }
    }
}
