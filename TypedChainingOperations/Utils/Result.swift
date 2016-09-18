//
//  Result.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 03/09/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

enum Result<T> {
  case success(T)
  case failure(Error)
}
