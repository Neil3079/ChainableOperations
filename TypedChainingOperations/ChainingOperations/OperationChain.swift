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
  
  private init(operation: InitialChainableOperation<OutputType> ) {
    self.operations = [operation]
  }
  
  /**
   Creates a new OperationChain by adding a new ChainableOperation to the previous chain.
   The OuputType of the last operation in the chain must be the same as the InputType of the new
   ChainableOperation
   
   - parameter previousChain: The OperationChain to add the new operation to
   - parameter newOperation:  The new operation to be added
   
   - returns: A new OperationChain
   */
  static func join<X,Y,Z>(previousChain: OperationChain<Z,X>, newOperation: ChainableOperation<X,Y>) -> OperationChain<X,Y> {
    return OperationChain<X,Y>(operations: previousChain.operations, lastOperation: newOperation)
  }
  
  /**
   Creates a new OperationChain with an initial chainable operation.
   
   - parameter operation: The initial input operation for the operation chain
   
   - returns: A new OperationChain
   */
  static func create<Y>(operation: InitialChainableOperation<Y>) -> OperationChain<Void,Y> {
    return OperationChain<Void, Y>(operation: operation)
  }
}

infix operator ==> { associativity left precedence 100 }

/**
 Create an Operation chain with an InitialChainableOperation and a ChainableOperation. The OutputType 
 of the InitialChainableOperation must be the same as the InputType of the ChainableOperation.
 
 - parameter lhs: The initial chainable operation.
 - parameter rhs: The next chianable operation
 
 - returns: A new operation chain.
 */
func ==><T,U>(lhs: InitialChainableOperation<T>, rhs: ChainableOperation<T,U>) -> OperationChain<T,U> {
  let firstChain = OperationChain<Void, String>.create(lhs)
  return OperationChain<String, String>.join(firstChain, newOperation: rhs)
}

/**
 Creates a new OperationChain from an existing OperationChain and a new ChainableOperation.
 
 - parameter lhs: The initial operation chain.
 - parameter rhs: The chainable operation to add to the chain.
 
 - returns: A new operation chain.
 */
func ==><X,Y,Z>(lhs: OperationChain<X,Y>, rhs: ChainableOperation<Y,Z>) -> OperationChain<Y,Z> {
  return  OperationChain<Void, String>.join(lhs, newOperation: rhs)
}
