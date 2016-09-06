//
//  OperationQueue+AddOperationChain.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 11/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

extension NSOperationQueue {
  func addOperationChain<T,U>(operationChain: OperationChain<T,U>) {
    operationChain.operations.flatMap { $0 as? NSOperation }.forEach { addOperation($0) }
  }
}
