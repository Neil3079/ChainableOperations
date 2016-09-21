//
//  OperationQueue+AddOperationChain.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 11/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

public extension OperationQueue {
  func addOperationChain<T,U>(_ operationChain: OperationChain<T,U>) {
    operationChain.operations.flatMap { $0 as? Operation }.forEach { addOperation($0) }
  }
}
