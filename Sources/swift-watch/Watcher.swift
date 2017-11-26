// This Source Code Form is subject to the terms of the Mozilla Public
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// License, v. 2.0. If a copy of the MPL was not distributed with this

import Foundation

import Files
import SKQueue

class Watcher {
    enum State {
        case started, stopped
    }

    let directoryURL: URL
    let configuration: Configuration
    private var state: State = .stopped
    private var skipped: Bool = false
    private var closure: ((QueueWatcherChange, URL) throws -> ())?
    private var semaphore: DispatchSemaphore = .init(value: 0)
    private var queueWatcher: QueueWatcher?

    @discardableResult
    required init(directoryURL: URL, configuration: Configuration) {
        self.directoryURL = directoryURL
        self.configuration = configuration
    }

    func watch(closure: @escaping (QueueWatcherChange, URL) -> ()) {
        while true {
            self.closure = closure
            self.semaphore = DispatchSemaphore(value: 0)
            self.queueWatcher = QueueWatcher(directoryURL: self.directoryURL)
            self.queueWatcher?.delegate = self
            self.semaphore.wait()
        }
    }
}

extension Watcher: QueueWatcherDelegate {
    func watcher(_ watcher: QueueWatcher, observedChange change: QueueWatcherChange, at directoryURL: URL) {
        guard case .stopped = self.state else {
            self.skipped = true
            return
        }
        guard let closure = self.closure else {
            return
        }
        self.state = .started
        defer {
            self.state = .stopped
            self.semaphore.signal()
        }
        do {
            try closure(change, directoryURL)
            print("Finished running with success.".lightGreen)
        } catch {
            print("Finished running with failure.".lightRed)
        }
    }
}

typealias QueueWatcherChange = SKQueueNotification

protocol QueueWatcherDelegate: class {
    func watcher(_ watcher: QueueWatcher, observedChange change: QueueWatcherChange, at directoryURL: URL)
}

class QueueWatcher {
    weak var delegate: QueueWatcherDelegate?
    private var children: [QueueWatcher] = []
    private let directoryURL: URL
    private lazy var queue: SKQueue = SKQueue(delegate: self)!

    init(directoryURL: URL) {
        self.directoryURL = directoryURL
        self.queue.addPath(directoryURL.path)
        self.children = try! Folder(path: directoryURL.path).subfolders.map { directory in
            return QueueWatcher(directoryURL: URL(fileURLWithPath: directory.path))
        }
        self.children.forEach { child in
            child.delegate = self
        }
    }
}

extension QueueWatcher: QueueWatcherDelegate {
    func watcher(_ watcher: QueueWatcher, observedChange change: QueueWatcherChange, at directoryURL: URL) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.watcher(self, observedChange: change, at: directoryURL)
    }
}

extension QueueWatcher: SKQueueDelegate {
    func receivedNotification(_ notification: SKQueueNotification, path: String, queue: SKQueue) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.watcher(self, observedChange: notification, at: self.directoryURL)
    }
}
