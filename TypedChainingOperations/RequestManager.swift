//
//  RequestManager.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

struct RequestManager {
  
  let session: NSURLSession
  
  init(session: NSURLSession = NSURLSession.sharedSession()) {
    self.session = session
  }
  
  func performRequest(urlRequest: NSURLRequest, completion: (Result<[String: AnyObject]> -> Void)) {
    session.dataTaskWithRequest(urlRequest) {data, response, error in
      guard let data = data else {
        completion(.Failure(NSError(code: .ExecutionFailed)))
        return
      }
      
      guard let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? [String: AnyObject] else {
        completion(.Failure(NSError(domain: "JSONParsing", code: 400, userInfo: nil)))
        return
      }
      
      completion(.Success(jsonDictionary))
      }.resume()
  }
}
