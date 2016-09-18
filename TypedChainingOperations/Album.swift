//
//  Album.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

struct Album {
  let name: String
}

extension Album : DictionaryRepresentable {
  init?(dictionary: [String: AnyObject]) {
    guard let name = dictionary["name"] as? String else {
      return nil
    }
    self.name = name
  }
  
  func dictionaryRepresentation() -> [String : AnyObject] {
    return ["name": name as AnyObject]
  }
}
