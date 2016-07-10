//
//  ChainableOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

protocol InputOperationType {
  func setInput(input: Any)
}

protocol ChainableOperationType: class {
  weak var nextOperation: ChainableOperationType? { get set }
}

class ChainableOperation<Input: Any, Output: Any>: Operation, ChainableOperationType, InputOperationType {
  
  private var input: Input?
  weak var nextOperation: ChainableOperationType?
  
  override func execute() {
    guard let input = input else {
      fatalError("Something went wrong this should not be called")
    }
    performTask(input)
  }
  
  func performTask(input: Input) {
    fatalError("Must be overriden by subclass")
  }
  
  final func finish(result: Result<Output>) {
    switch result {
    case .Success(let output):
      guard let nextOperation = nextOperation as? InputOperationType else {
        fatalError("This should never be called")
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
