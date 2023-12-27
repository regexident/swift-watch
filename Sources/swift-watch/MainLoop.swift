// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class MainLoop {
    let watcher: Watcher
    let runner: Runner
    let taskSuite: TaskSuite
    let configuration: Configuration

    private var shouldPostpone: Bool {
        return self.configuration.postpone
    }

    init(configuration: Configuration, observers: [RunnerObserver]) {
        let runner = Runner(configuration: configuration, observers: observers)
        let taskSuite = TaskSuite(configuration: configuration)
        self.watcher = Watcher(configuration: configuration) { changedURL in
            runner.run(taskSuite: taskSuite, changedURL: changedURL)
        }
        self.runner = runner
        self.taskSuite = taskSuite
        self.configuration = configuration
    }

    func start() throws {
        if !self.shouldPostpone {
            self.runner.run(taskSuite: self.taskSuite, changedURL: nil)
        }
        self.watcher.startWatching()
    }
}
