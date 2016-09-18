import Foundation

open class BaseAsynchronousOperation: Operation {
  
  open override var isAsynchronous: Bool {
    get{
      return true
    }
  }
  
  fileprivate var _executing: Bool = false
  open override var isExecuting:Bool {
    get { return _executing }
    set {
      willChangeValue(forKey: "isExecuting")
      _executing = newValue
      didChangeValue(forKey: "isExecuting")
      if _cancelled == true {
        self.isFinished = true
      }
    }
  }
  fileprivate var _finished: Bool = false
  open override var isFinished: Bool {
    get { return _finished }
    set {
      willChangeValue(forKey: "isFinished")
      _finished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }
  
  fileprivate var _cancelled: Bool = false
  open override var isCancelled: Bool {
    get { return _cancelled }
    set {
      willChangeValue(forKey: "isCancelled")
      _cancelled = newValue
      didChangeValue(forKey: "isCancelled")
    }
  }
  
  public final override func start() {
    super.start()
    self.isExecuting = true
  }
  
  public final override func main() {
    if isCancelled {
      isExecuting = false
      isFinished = true
      return
    }
    execute()
  }
  
  open func execute() {
    assertionFailure("execute must be overriden")
    finish()
  }
  
  public final func finish(withErrors errors: [NSError] = []) {
    self.isFinished = true
    self.isExecuting = false
  }
  
  public final override func cancel() {
    super.cancel()
    isCancelled = true
    if isExecuting {
      isExecuting = false
      isFinished = true
    }
  }
}
