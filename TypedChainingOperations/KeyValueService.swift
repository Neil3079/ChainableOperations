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
  
  private let store: KeyValueStoreType
  
  init(store: KeyValueStoreType = NSUserDefaults.standardUserDefaults()) {
    self.store = store
  }
  
  //MARK:- DictionaryRepresentable Value
  func valueForKey<T: DictionaryRepresentable>(key: KeyValueServiceKeys) -> T? {
    
    guard let dictionaryValue = store.objectForKey(key.rawValue) as? [String: AnyObject] else {
      return nil
    }
    return T(dictionary: dictionaryValue)
  }
  
  func storeValueForKey<T: DictionaryRepresentable>(value: T?, key: KeyValueServiceKeys) {
    store.setObject(value?.dictionaryRepresentation(), forKey: key.rawValue)
  }
  
  //MARK:- DictionaryRepresentable Array
  func arrayForKey<T: DictionaryRepresentable>(key: KeyValueServiceKeys) -> [T]? {
    guard let dictionaryValues = store.objectForKey(key.rawValue) as? [[String: AnyObject]] else {
      return nil
    }
    return dictionaryValues.flatMap { T(dictionary: $0) }
  }
  
  func storeArrayForKey<T: DictionaryRepresentable>(values: [T]?, key: KeyValueServiceKeys) {
    let dictionaryValues = (values?.map { $0.dictionaryRepresentation() })
    store.setObject(dictionaryValues, forKey: key.rawValue)
  }
  
  //MARK:- Remove Object
  func removeValueForKey(key: KeyValueServiceKeys) {
    store.setObject(nil, forKey: key.rawValue)
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