//
//  KeyValueService.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

enum KeyValueServiceKeys: String {
  case FavouriteAlbums
}

struct KeyValueService {
  
  fileprivate let store: KeyValueStoreType
  
  init(store: KeyValueStoreType = UserDefaults.standard) {
    self.store = store
  }
  
  //MARK:- DictionaryRepresentable Value
  func valueForKey<T: DictionaryRepresentable>(_ key: KeyValueServiceKeys) -> T? {
    
    guard let dictionaryValue = store.object(forKey: key.rawValue) as? [String: AnyObject] else {
      return nil
    }
    return T(dictionary: dictionaryValue)
  }
  
  func storeValueForKey<T: DictionaryRepresentable>(_ value: T?, key: KeyValueServiceKeys) {
    store.set(value?.dictionaryRepresentation(), forKey: key.rawValue)
  }
  
  //MARK:- DictionaryRepresentable Array
  func arrayForKey<T: DictionaryRepresentable>(_ key: KeyValueServiceKeys) -> [T]? {
    guard let dictionaryValues = store.object(forKey: key.rawValue) as? [[String: AnyObject]] else {
      return nil
    }
    return dictionaryValues.flatMap { T(dictionary: $0) }
  }
  
  func storeArrayForKey<T: DictionaryRepresentable>(_ values: [T]?, key: KeyValueServiceKeys) {
    let dictionaryValues = (values?.map { $0.dictionaryRepresentation() })
    store.set(dictionaryValues, forKey: key.rawValue)
  }
  
  //MARK:- Remove Object
  func removeValueForKey(_ key: KeyValueServiceKeys) {
    store.set(nil, forKey: key.rawValue)
  }
}


protocol DictionaryRepresentable {
  
  /**
   Returns the dictionary representation of the conforming object.
   
   - returns: Dictionary representation of object.
   */
  func dictionaryRepresentation() -> [String: AnyObject]
  
  /**
   Required initialiser which allows the object to attempt to construct
   itself from a dictionary representation. Returns nil if the object
   is unable to create itself from the passed in dictionary.
   
   - parameter dictionary: Dictionary representation of object.
   */
  init?(dictionary: [String: AnyObject])
}
