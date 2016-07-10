//
//  AppDelegate.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let operationQueue = OperationQueue()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let operationChain =  TestChainableOperationOne()
                          ==> TestChainableOperationTwo()
                          ==> TestChainableOperationThree()
    
    operationQueue.addOperationChain(operationChain)
    
    return true
  }
}

