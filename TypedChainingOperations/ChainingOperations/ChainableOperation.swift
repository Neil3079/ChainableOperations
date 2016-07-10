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
  
  /**
   Sets the input on the operation, this should never be called directly
   
   - parameter input: The input of the operation.
   */
  func setInput(input: Any)
}

class ChainableOperation<Input: Any, Output: Any>: Operation, ChainableOperationType {
  
  private var input: Input?
  weak var nextOperation: ChainableOperationType?
  
  /**
   This should never be called directly
   */
  override final func execute() {
    guard let input = input else {
      fatalError("Something went wrong this should not be called")
    }
    performTask(input)
  }
  
  /**
   The actual work to be performed by the operation.
   
   - parameter input: The input required by ther operation,this will have been supplied by the previous 
                      operation in the operation chain.
   */
  func performTask(input: Input) {
    fatalError("Must be overriden by subclass")
  }
  
  /**
   Finishes the operation with either an error or the output value of the operation. If Success with
   the output value the output value is passed to the next operation in the chain.
   
   - parameter result: The result of the operation.
   */
  final func finish(result: Result<Output>) {
    switch result {
    case .Success(let output):
      guard let nextOperation = nextOperation else {
        finishWithError(nil)
        return
      }
      nextOperation.setInput(output)
      finishWithError(nil)
    case .Failure(let error):
      finishWithError(error)
    }
  }

  final func setInput(input: Any) {
    self.input = input as? Input
  }
}
