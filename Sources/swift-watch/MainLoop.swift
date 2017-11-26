// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

class MainLoop {
    let watcher: Watcher
    let runner: Runner

    init(directoryURL: URL, configuration: Configuration) {
        self.watcher = Watcher(directoryURL: directoryURL, configuration: configuration)
        self.runner = Runner(directoryURL: directoryURL, configuration: configuration)
    }

    func start() throws {
        print()
        try? self.runner.run()
        self.watcher.watch { change, directoryURL in
            try? self.runner.run()
        }
    }
}
