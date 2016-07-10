//
//  TestChainableOperations.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

class TestChainableOperationOne: NoInputChainableOperation<String> {
  override func performTask() {
    let firstString = "Hello"
    finish(.Success(firstString))
  }
}

class TestChainableOperationTwo: ChainableOperation<String, String> {
  override func performTask(input: String) {
    let secondString = "\(input) World"
    finish(.Success(secondString))
  }
}

class TestChainableOperationThree: ChainableOperation<String, Void> {
  override func performTask(input: String) {
    print(input)
  }
}
