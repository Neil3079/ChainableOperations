//
//  InitialChainableOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

class NoInputChainableOperation<Output: Any>: Operation, ChainableOperationType{
  
  weak var nextOperation: ChainableOperationType?
  
  override final func execute() {
    performTask()
  }
  
  
  func performTask() {
    fatalError("Must be overriden by subclass")
  }
  
  final func finish(result: Result<Output>) {
    switch result {
    case .Success(let output):
      guard let nextOperation = nextOperation as? InputOperationType else {
        fatalError()
      }
      nextOperation.setInput(output)
      finishWithError(nil)
    case .Failure(let error):
      finishWithError(error)
    }
  }
}
