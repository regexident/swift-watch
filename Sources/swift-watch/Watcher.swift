// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Files
import SKQueue

class Watcher {
    enum State {
        case idle, busy
    }

    let configuration: Configuration
    private var state: State = .idle
    private var skipped: Bool = false
    private var closure: (URL) -> ()
    private lazy var queue: SKQueue = SKQueue(delegate: self)!

    private var directoryURL: URL {
        return self.configuration.directoryURL
    }

    @discardableResult
    required init(configuration: Configuration, closure: @escaping (URL) -> ()) {
        self.configuration = configuration
        self.closure = closure
    }

    func startWatching() {
        self.recursivelyAdd(path: self.directoryURL.path)
    }

    func stopWatching() {
        self.queue.removeAllPaths()
    }

    private func recursivelyAdd(path: String) {
        let folder = try! Folder(path: path)
        folder.subfolders.forEach { directory in
            self.queue.addPath(directory.path)
            self.recursivelyAdd(path: directory.path)
        }
        folder.files.forEach { file in
            self.queue.addPath(file.path)
        }
    }
}

extension Watcher: SKQueueDelegate {
    func receivedNotification(_ notification: SKQueueNotification, path: String, queue: SKQueue) {
        guard !notification.intersection([.Rename, .Write, .Delete, .SizeIncrease]).isEmpty else {
            return
        }
        guard case .idle = self.state else {
            self.skipped = true
            return
        }
        let fileURL = URL(fileURLWithPath: path)
        self.state = .busy
        self.closure(fileURL)
        self.state = .idle
    }
}
