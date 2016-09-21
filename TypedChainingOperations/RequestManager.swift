//
//  RequestManager.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation
import NHChainableOperations

struct RequestManager {
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func performRequest(_ urlRequest: URLRequest, completion: @escaping ((Result<[String: AnyObject]>) -> Void)) {
    session.dataTask(with: urlRequest, completionHandler: {data, response, error in
      guard let data = data else {
        completion(.failure(RequestManagerError.invalidData))
        return
      }
      
      guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: AnyObject] else {
        completion(.failure(NSError(domain: "JSONParsing", code: 400, userInfo: nil)))
        return
      }
      
      completion(.success(jsonDictionary))
      }) .resume()
  }
}

enum RequestManagerError: Error {
  case invalidData
}
