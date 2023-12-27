// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Rainbow

class Runner {
    let configuration: Configuration
    private let queue: DispatchQueue = .init(label: "swift-watch")
    let observers: [RunnerObserver]
    var workItem: DispatchWorkItem?
    var currentTime: UInt = 0

    private var isDryRun: Bool {
        return self.configuration.dryRun
    }

    private var isClearing: Bool {
        return self.configuration.clear
    }

    init(configuration: Configuration, observers: [RunnerObserver]) {
        self.configuration = configuration
        self.observers = observers
    }

    func run(taskSuite: TaskSuite, changedURL: URL?) {
        self.currentTime += 1
        let scheduleTime = self.currentTime
        if let workItem = self.workItem {
            workItem.cancel()
            self.workItem = nil
        }
        let workItem = DispatchWorkItem {
            defer { self.workItem = nil }
            if self.isClearing {
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
                self.delay()
            }
            let report = TaskSuiteReport(reports: taskReports)
            self.broadcast(event: .exitedTaskSuite(report))
        }
        self.workItem = workItem
        self.queue.asyncAfter(
            deadline: .now() + .seconds(1),
            execute: workItem
        )
    }

    private func run(task: Task) -> TaskReport {
        let report: TaskReport
        var statusCode: Int32 = 0
        self.broadcast(event: .enteredTask(task))
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
        report = TaskReport(task: task, result: result)
        self.broadcast(event: .exitedTask(report))
        return report
    }

    private func delay() {
        usleep(500_000) // 0.5 sec
    }

    private func broadcast(event: Event) {
        for observer in self.observers {
            observer.observe(event: event)
        }
    }
}
