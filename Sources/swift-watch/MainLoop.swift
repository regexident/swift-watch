// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class MainLoop {
    let watcher: Watcher
    let runner: Runner
    let taskSuite: TaskSuite

    init(directoryURL: URL, configuration: Configuration, observers: [RunnerObserver]) {
        self.watcher = Watcher(
            directoryURL: directoryURL,
            configuration: configuration
        )
        self.runner = Runner(
            directoryURL: directoryURL,
            configuration: configuration,
            observers: observers
        )
        self.taskSuite = TaskSuite(
            configuration: configuration
        )
    }

    func start() throws {
        let _ = self.runner.run(taskSuite: self.taskSuite)
        self.watcher.watch { change, directoryURL in
            let _ = self.runner.run(taskSuite: self.taskSuite)
        }
    }
}
