//
//  TestChainableOperations.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

struct Data {
  let something: Int
  let somethingElse: String
}

struct OtherDataType {
  let something: Int
  let somethingElse: String
  
  func printInfo() {
    print("\(something), \(somethingElse)")
  }
}

class TestChainableOperationTwo: ChainableOperation<Data, OtherDataType> {
  override func performTask(input: Data) {
    let otherData = OtherDataType(something: input.something, somethingElse: input.somethingElse)
    finish(.Success(otherData))
  }
}

class TestChainableOperationThree: ChainableOperation<OtherDataType, Void> {
  override func performTask(input: OtherDataType) {
    input.printInfo()
    finish(.Success())
  }
}

class TestChainableOperationFour: ChainableOperation<Void, String> {
  override func performTask(input: Void) {
    print("Void Operation mother fucker")
    finish(.Success("Void Input String Output mother fucker"))
  }
}

class TestChainableOperationFive: ChainableOperation<String, Void> {
  override func performTask(input: String) {
    print(input)
    finish(.Success())
  }
}
