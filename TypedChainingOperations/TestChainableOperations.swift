//
//  TestChainableOperations.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation
import NHChainableOperations

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

class TestChainableOperationOne: ChainableOperation<Void, Data> {
  override func main(_ input: Void) {
    let otherData = Data(something: 1, somethingElse: "hello")
    finish(.success(otherData))
  }
}

class TestChainableOperationTwo: ChainableOperation<Data, OtherDataType> {
  override func main(_ input: Data) {
    let otherData = OtherDataType(something: input.something, somethingElse: input.somethingElse)
    finish(.success(otherData))
  }
}

class TestChainableOperationThree: ChainableOperation<OtherDataType, Void> {
  override func main(_ input: OtherDataType) {
    input.printInfo()
    finish(.success())
  }
}

class TestChainableOperationFour: ChainableOperation<Void, String> {
  override func main(_ input: Void) {
    print("Void Operation")
    finish(.success("Void Input String Output"))
  }
}

class TestChainableOperationFive: ChainableOperation<String, Void> {
  override func main(_ input: String) {
    print(input)
    finish(.success())
  }
}
