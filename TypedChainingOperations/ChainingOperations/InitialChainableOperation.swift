//
//  InitialChainableOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

class InitialChainableOperation<Output: Any>: Operation, ChainableOperationType {
  
  /// The next operaation to be performed
  weak var nextOperation: ChainableOperationType?
  
  /**
   This class should never be called directly
   */
  override final func execute() {
    performTask()
  }
  
  /**
   Contains the work to be performed by the operation. The operation will not finish until finish() 
   is called. Subclasses should call finish(result: Result<Output>) as this does important work to
   pass the output to the next operation.
   */
  func performTask() {
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
        fatalError()
      }
      nextOperation.setInput(output)
      finishWithError(nil)
    case .Failure(let error):
      finishWithError(error)
    }
  }
  
  func setInput(input: Any) {
    fatalError("Input shoult never be set on this type of ChainableOperation")
  }
}
