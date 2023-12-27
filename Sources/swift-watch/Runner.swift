// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Rainbow

class Runner {
    let configuration: Configuration
    let observers: [RunnerObserver]
    var currentTime: UInt = 0

    private let queue: DispatchQueue = .init(label: "swift-watch")

    private var isRunning: Bool = false

    private var isDryRun: Bool {
        return self.configuration.dryRun
    }

    private var shouldClear: Bool {
        return self.configuration.clear
    }

    init(configuration: Configuration, observers: [RunnerObserver]) {
        self.configuration = configuration
        self.observers = observers
    }

    func schedule(taskSuite: TaskSuite, changedURL: URL?) {
        guard !self.isRunning else {
            if let changedURL = changedURL {
                let directoryURL = self.configuration.directoryURL

                let directoryPath: String
                var filePath: String
                if #available(macOS 13.0, *) {
                    directoryPath = directoryURL.path()
                    filePath = String(changedURL.path().trimmingPrefix(directoryPath))
                } else {
                    directoryPath = directoryURL.path
                    filePath = String(changedURL.path.dropFirst(directoryPath.count))
                }

                print("Ignoring file change while running tasks: ./\(filePath)")
            }
            return
        }

        self.currentTime += 1
        let scheduleTime = self.currentTime

        self.queue.async { [weak self] in
            guard let self else {
                return
            }

            self.isRunning = true

            defer {
                self.isRunning = false
            }

            if self.shouldClear {
                Process.execute(command: "clear")
            }

            self.broadcast(event: .enteredTaskSuite(taskSuite))

            var taskReports: [TaskReport] = []
            for task in taskSuite.tasks {
                guard scheduleTime == self.currentTime else {
                    break
                }
                let result = self.run(task: task).result
                let report = TaskReport(task: task, result: result)
                taskReports.append(report)
                guard result.isSuccess else {
                    break
                }
            }

            let report = TaskSuiteReport(reports: taskReports)
            self.broadcast(event: .exitedTaskSuite(report))
        }
    }

    private func run(task: Task) -> TaskReport {
        self.broadcast(event: .enteredTask(task))
        var statusCode: Int32 = 0
        if self.isDryRun {
            statusCode = 0
        } else {
            let invocation = task.invocation
            statusCode = Process.execute(command: invocation)
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

    private func broadcast(event: Event) {
        for observer in self.observers {
            observer.observe(event: event)
        }
    }
}
