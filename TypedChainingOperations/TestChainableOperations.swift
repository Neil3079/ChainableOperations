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

class TestChainableOperationOne: ChainableOperation<Void, Data> {
  override func main(input: Void) {
    let otherData = Data(something: 1, somethingElse: "hello")
    finish(.Success(otherData))
  }
}

class TestChainableOperationTwo: ChainableOperation<Data, OtherDataType> {
  override func main(input: Data) {
    let otherData = OtherDataType(something: input.something, somethingElse: input.somethingElse)
    finish(.Success(otherData))
  }
}

class TestChainableOperationThree: ChainableOperation<OtherDataType, Void> {
  override func main(input: OtherDataType) {
    input.printInfo()
    finish(.Success())
  }
}

class TestChainableOperationFour: ChainableOperation<Void, String> {
  override func main(input: Void) {
    print("Void Operation")
    finish(.Success("Void Input String Output"))
  }
}

class TestChainableOperationFive: ChainableOperation<String, Void> {
  override func main(input: String) {
    print(input)
    finish(.Success())
  }
}
