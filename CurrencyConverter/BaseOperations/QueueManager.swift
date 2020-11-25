//
//  QueueManager.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
public final class QueueManager: DownloadQueueProtocol {
  public static let shared = QueueManager()

  lazy var downloadQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.name = "com.ankushkumarsingh.downloadQueue"
    queue.maxConcurrentOperationCount = 6
    return queue
  }()

  private init() {
  }

  public func enqueueDownload(_ operation: Operation) {
    if !downloadQueue.operations.contains(operation) {
      if let name = operation.name, !isOperationInProgress(forNames: [name]) {
        if !(operation.isFinished || operation.isExecuting) {
          downloadQueue.addOperation(operation)
        }
      }
    }
  }

  public func isOperationInProgress(forNames names: [String]) -> Bool {
    let operationNames = downloadQueue.operations.compactMap {$0.name}
    let intersection = Set(operationNames).intersection(names)
    if !intersection.isEmpty {
      return true
    }
    return false
  }
}
