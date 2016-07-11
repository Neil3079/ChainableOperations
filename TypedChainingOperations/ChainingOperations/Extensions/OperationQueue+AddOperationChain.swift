//
//  OperationQueue+AddOperationChain.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 11/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

extension OperationQueue {
  func addOperationChain<T,U>(operationChain: OperationChain<T,U>) {
    let operations = operationChain.operations.flatMap { $0 as? NSOperation }
    addOperations(operations, waitUntilFinished: false)
  }
}
