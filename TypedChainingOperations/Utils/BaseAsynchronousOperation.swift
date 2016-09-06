import Foundation

public class BaseAsynchronousOperation: NSOperation {
  
  public override var asynchronous: Bool {
    get{
      return true
    }
  }
  
  private var _executing: Bool = false
  public override var executing:Bool {
    get { return _executing }
    set {
      willChangeValueForKey("isExecuting")
      _executing = newValue
      didChangeValueForKey("isExecuting")
      if _cancelled == true {
        self.finished = true
      }
    }
  }
  private var _finished: Bool = false
  public override var finished: Bool {
    get { return _finished }
    set {
      willChangeValueForKey("isFinished")
      _finished = newValue
      didChangeValueForKey("isFinished")
    }
  }
  
  private var _cancelled: Bool = false
  public override var cancelled: Bool {
    get { return _cancelled }
    set {
      willChangeValueForKey("isCancelled")
      _cancelled = newValue
      didChangeValueForKey("isCancelled")
    }
  }
  
  public final override func start() {
    super.start()
    self.executing = true
  }
  
  public final override func main() {
    if cancelled {
      executing = false
      finished = true
      return
    }
    execute()
  }
  
  public func execute() {
    assertionFailure("execute must be overriden")
    finish()
  }
  
  public final func finish(withErrors errors: [NSError] = []) {
    self.finished = true
    self.executing = false
  }
  
  public final override func cancel() {
    super.cancel()
    cancelled = true
    if executing {
      executing = false
      finished = true
    }
  }
}
