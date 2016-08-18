//
//  KeyValueStore.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

protocol KeyValueStoreType {
  
  /**
   Will return Optional AnyObject stored against a unique key.
   If object does not exist will return nil instead.
   
   - parameter defaultName: Unique key used to identify object.
   
   - returns: Optional object stored against key
   */
  func objectForKey(defaultName: String) -> AnyObject?
  
  /**
   Sets Optional AnyObject against a unique key. If a value for
   key already exists it will be overwritten.
   
   - parameter value:  Object to be stored.
   - parameter forKey: Unique key to identify Object.
   */
  func setObject(value: AnyObject?, forKey: String)
}

extension NSUserDefaults: KeyValueStoreType {}

public extension NSThread {
  /**
   Checks the current thread and runs the given closure synchronously on the main thread.
   
   - parameter mainThreadClosure: the closure to call on the main thread
   */
  static func executeOnMain(mainThreadClosure: () -> Void) {
    if self.currentThread() == self.mainThread() {
      mainThreadClosure()
    } else {
      
      let queue = dispatch_get_main_queue()
      dispatch_sync(queue, {
        mainThreadClosure()
      })
      
    }
  }
  
}
