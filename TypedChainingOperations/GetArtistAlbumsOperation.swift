//
//  GetArtistAlbumsOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

protocol GetArtistAlbumsOperationDelegate: class {
  func getArtistAlbumsOperationDidFinish(albums: [Album])
}

class GetArtistAlbumsOperation: ChainableOperation<String, [Album]> {
  
  let requestManager = RequestManager()
  weak var delegate:  GetArtistAlbumsOperationDelegate?
  
  init(delegate: GetArtistAlbumsOperationDelegate) {
    self.delegate = delegate
  }
  
  override func main(input: String) {
    let urlString = "https://api.spotify.com/v1/artists/\(input)/albums"
    guard let url = NSURL(string: urlString) else {
      finish(.Failure(NSError(code: .ExecutionFailed)))
      return
    }
    let request = NSURLRequest(URL: url)
    requestManager.performRequest(request) { [weak self] result in
      switch result {
      case .Success(let responseDictionary):
        guard let albumArray = responseDictionary["items"] as? [[String: AnyObject]] else {
          self?.finish(.Failure(NSError(code: .ExecutionFailed)))
          return
        }
        let albums = albumArray.flatMap { Album(dictionary: $0) }
        NSThread.executeOnMain {
          self?.delegate?.getArtistAlbumsOperationDidFinish(albums)
        }
        self?.finish(.Success(albums))
      case .Failure(let error):
        self?.finish(.Failure(error))
      }
    }
  }
}
