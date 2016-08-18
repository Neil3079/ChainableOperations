//
//  OperationChain.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

struct OperationChain<LastOperationInputType, LastOperationOutputType> {
  let operations: [ChainableOperationType]
  
  private init(operations: [ChainableOperationType], lastOperation: ChainableOperation<LastOperationInputType, LastOperationOutputType> ) {
    var allOperations = operations
    guard let previousLastOperation = allOperations.last else {
      allOperations.append(lastOperation)
      self.operations = allOperations
      return
    }
    
    operations.forEach {
      if let operation = $0 as? NSOperation {
        lastOperation.addDependency(operation)
      }
    }
    previousLastOperation.nextOperation = lastOperation
    allOperations.append(lastOperation)
    self.operations = allOperations
  }
  
  /**
   Creates a new OperationChain by adding a new ChainableOperation to the previous chain.
   The OuputType of the last operation in the chain must be the same as the InputType of the new
   ChainableOperation.
   
   - parameter previousChain: The OperationChain to add the new operation to
   - parameter newOperation:  The new operation to be added
   
   - returns: A new OperationChain
   */
  static func join<X,Y,Z>(previousChain: OperationChain<Z,X>, newOperation: ChainableOperation<X,Y>) -> OperationChain<X,Y> {
    return OperationChain<X,Y>(operations: previousChain.operations, lastOperation: newOperation)
  }
  
  /**
   Creates a new OperationChain by combining two chainable operations. The first Operation in the chain
   must have Void as its Input type.
   
   - parameter firstChainableOperation:  The first operation of the chain. This operation must have nil as the input type
   - parameter secondChainableOperation: The second chainable operation. This operations input type must equal the Output Type of the firstChainableOperation
   
   - returns: A new OperationChain
   */
  static func create<Y,Z>(firstChainableOperation: ChainableOperation<Void,Y>, secondChainableOperation: ChainableOperation<Y,Z>) -> OperationChain<Y,Z> {
    return OperationChain<Y,Z>(operations: [firstChainableOperation], lastOperation: secondChainableOperation)
  }
}

infix operator ==> { associativity left precedence 100 }

/**
 Creates a new OperationChain from an existing OperationChain and a new ChainableOperation.
 
 - parameter lhs: The initial operation chain.
 - parameter rhs: The chainable operation to add to the chain.
 
 - returns: A new operation chain.
 */
func ==><X,Y,Z>(lhs: OperationChain<X,Y>, rhs: ChainableOperation<Y,Z>) -> OperationChain<Y,Z> {
  return  OperationChain<X, Y>.join(lhs, newOperation: rhs)
}

/**
 Creates a new OperationChain by combining two chainable operations. The first Operation in the chain
 must have Void as its Input type.
 
 - parameter lhs: The first operation of the chain. This operation must have nil as the input type
 - parameter rhs: The second chainable operation. This operations input type must equal the Output Type of the firstChainableOperation
 
 - returns: A new OperationChain
 */
func ==><Y,Z>(lhs: ChainableOperation<Void,Y>, rhs: ChainableOperation<Y,Z>) -> OperationChain<Y,Z> {
  return OperationChain<Y,Z>.create(lhs, secondChainableOperation: rhs)
}
