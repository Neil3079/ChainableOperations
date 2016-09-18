//
//  ChainableOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

protocol ChainableOperationType: class {
  /// The next operation to be performed
  weak var nextOperation: ChainableOperationType? { get set }
  
  var didFail: Bool { get }
  
  /**
   Sets the input on the operation, this should never be called directly
   
   - parameter input: The input of the operation.
   */
  func setInput(_ input: Any)
}

class ChainableOperation<Input, Output>: BaseAsynchronousOperation, ChainableOperationType {
  
  fileprivate var input: Input?
  weak var nextOperation: ChainableOperationType?
  fileprivate(set) var didFail = false
  
  /**
   This should never be called directly
   */
  override final func execute() {
    if hasFailingDependencies() {
      finish(.failure(ChainableOperationError.dependanciesFailed))
      return
    }
    
    guard let input = input  else {
      if let void = () as? Input , self.input is Void? {
        main(void)
        return
      }
      fatalError("Something went wrong this should not be called")
    }
     
    main(input)
  }
  
  /**
   The actual work to be performed by the operation.
   
   - parameter input: The input required by ther operation, this will have been supplied by the previous
                      operation in the operation chain.
   */
  func main(_ input: Input) {
    fatalError("Must be overriden by subclass")
  }
  
  /**
   Finishes the operation with either an error or the output value of the operation. If Success with
   the output value the output value is passed to the next operation in the chain.
    
   - parameter result: The result of the operation.
   */
  final func finish(_ result: Result<Output>) {
    switch result {
    case .success(let output):
      guard let nextOperation = nextOperation else {
        finish()
        return
      }
      nextOperation.setInput(output)
      finish()
    case .failure(let error):
      didFail = true
      finish(withErrors: [error as NSError])
    }
  }

  final func setInput(_ input: Any) {
    self.input = input as? Input
  }
  
  fileprivate func hasFailingDependencies() -> Bool {
    let failingDependencies = dependencies.filter {
      if let chainableOperation = $0 as? ChainableOperationType , chainableOperation.didFail {
        return true
      }
      return false
    }
    return failingDependencies.count > 0
  }
}

enum ChainableOperationError: Error {
  case dependanciesFailed
}
