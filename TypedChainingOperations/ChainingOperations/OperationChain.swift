//
//  OperationChain.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

class OperationChain<Input, OutputType> {
  let operations: [ChainableOperationType]
  
  private init(operations: [ChainableOperationType], lastOperation: ChainableOperation<Input,OutputType> ) {
    var allOperations = operations
    guard let previousLastOperation = allOperations.last else {
      allOperations.append(lastOperation)
      self.operations = allOperations
      return
    }
    if let previousLastOperation  = previousLastOperation as? NSOperation {
      lastOperation.addDependency(previousLastOperation)
    }
    previousLastOperation.nextOperation = lastOperation
    allOperations.append(lastOperation)
    self.operations = allOperations
  }
  
  private init(operation: NoInputChainableOperation<OutputType> ) {
    self.operations = [operation]
  }
  
  static func join<X,Y,Z>(previousChain: OperationChain<Z,X>, newOperation: ChainableOperation<X,Y>) -> OperationChain<X,Y> {
    return OperationChain<X,Y>(operations: previousChain.operations, lastOperation: newOperation)
  }
  
  static func create<Y>(operation: NoInputChainableOperation<Y>) -> OperationChain<Void,Y> {
    return OperationChain<Void, Y>(operation: operation)
  }
}

infix operator ==> { associativity left precedence 100 }

func ==><T,U>(lhs: NoInputChainableOperation<T>, rhs: ChainableOperation<T,U>) -> OperationChain<T,U> {
  let firstChain = OperationChain<Void, String>.create(lhs)
  return OperationChain<String, String>.join(firstChain, newOperation: rhs)
}

func ==><X,Y,Z>(lhs: OperationChain<X,Y>, rhs: ChainableOperation<Y,Z>) -> OperationChain<Y,Z> {
  return  OperationChain<Void, String>.join(lhs, newOperation: rhs)
}
