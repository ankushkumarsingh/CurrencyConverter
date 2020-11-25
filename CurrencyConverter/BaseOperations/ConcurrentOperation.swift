//
//  ConcurrentOperation.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation

public enum Result<T> {
  case success(T)
  case failure(Error)
}

public class ConcurrentOperation<T>: Operation {
  private enum State: String {
    case ready = "isReady"
    case executing = "isExecuting"
    case finished = "isFinished"
  }

  typealias OperationCompletionHandler = (_ result: Result<T>) -> Void

  var completionHandler: (OperationCompletionHandler)?

  private var state: State = .ready {
    willSet {
      willChangeValue(forKey: newValue.rawValue)
      willChangeValue(forKey: state.rawValue)
    }
    didSet {
      didChangeValue(forKey: oldValue.rawValue)
      didChangeValue(forKey: state.rawValue)
    }
  }

  public override var isReady: Bool {
    return super.isReady && state == .ready
  }

  public override var isExecuting: Bool {
    return state == .executing
  }

  public override var isFinished: Bool {
    return state == .finished
  }

  public override var isConcurrent: Bool {
    return true
  }

  public override var isAsynchronous: Bool {
    return true
  }

  public override func start() {
    guard !isCancelled else {
      finish()
      return
    }
    if !isExecuting {
      state = .executing
    }
    main()
  }

  func finish() {
    if isExecuting {
      state = .finished
    }
  }

  func complete(result: Result<T>) {
    finish()
    if !isCancelled {
      if Thread.isMainThread {
        completionHandler?(result)
      } else {
        OperationQueue.main.addOperation {[weak self] in
          self?.completionHandler?(result)
        }
      }
    }
  }

  public override func cancel() {
    super.cancel()
    finish()
  }
  public override func main() {
    super.main()
  }
}
