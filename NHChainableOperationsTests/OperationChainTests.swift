//
//  OperationChainTests.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 21/09/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import XCTest
@testable import NHChainableOperations

class MockChainableOperation: ChainableOperation<Void, Void> {}

class OperationChainTests: XCTestCase {
  
  //MARK:- Create
  
  let lhsOperation = MockChainableOperation()
  let rhsOperation = MockChainableOperation()
  
  func test_create_addsLHSOperationAsDendancyOfRHS() {
    _ = OperationChain<Void, Void>.create(lhsOperation, secondChainableOperation: rhsOperation)
    XCTAssertNotNil(rhsOperation.dependencies.first)
    XCTAssertEqual(rhsOperation.dependencies.first, lhsOperation)
  }
  
  func test_create_addsRHSOperationAsNextOperationOfLHSOperation() {
    _ = OperationChain<Void, Void>.create(lhsOperation, secondChainableOperation: rhsOperation)
    XCTAssertNotNil(lhsOperation.nextOperation)
    guard let testOperation =  lhsOperation.nextOperation as? ChainableOperation<Void, Void> else {
      XCTFail("Next operation was set incorrectly")
      return
    }
    XCTAssertEqual(testOperation, rhsOperation)
  }
  
  func test_create_addsbothOperationsToItsOperationsList() {
    let testChain = OperationChain<Void, Void>.create(lhsOperation, secondChainableOperation: rhsOperation)
    XCTAssertEqual(testChain.operations.count, 2)
  }
  
  //MARK:- Join
  
  let previousChainOperationOne = MockChainableOperation()
  let previousChainOperationTwo = MockChainableOperation()
  let newOperation = MockChainableOperation()
  
  func test_join_addsPreviousOperationsAsDendancyOfNeOperation() {
    let previousOperationChain = OperationChain<Void, Void>.create(previousChainOperationOne, secondChainableOperation: previousChainOperationTwo)
    
    _ = OperationChain<Void, Void>.join(previousOperationChain, newOperation: newOperation)
    
    XCTAssertNotNil(newOperation.dependencies.first)
    XCTAssertEqual(newOperation.dependencies.first, previousChainOperationOne)
    XCTAssertEqual(newOperation.dependencies[1], previousChainOperationTwo)
  }
  
  func test_join_addsNewOperationAsNextOperationOfPreviousChainOperationTwo() {
    let previousOperationChain = OperationChain<Void, Void>.create(previousChainOperationOne, secondChainableOperation: previousChainOperationTwo)
    
    _ = OperationChain<Void, Void>.join(previousOperationChain, newOperation: newOperation)
    
    guard let testOperation =  previousChainOperationTwo.nextOperation as? ChainableOperation<Void, Void> else {
      XCTFail("Next operation was set incorrectly")
      return
    }
    XCTAssertEqual(testOperation, newOperation)
  }
  
  func test_create_addsallOperationsToItsOperationsList() {
    let previousOperationChain = OperationChain<Void, Void>.create(previousChainOperationOne, secondChainableOperation: previousChainOperationTwo)
    
    let testChain = OperationChain<Void, Void>.join(previousOperationChain, newOperation: newOperation)

    XCTAssertEqual(testChain.operations.count, 3)
  }
  
}
