//
//  GetArtistAlbumsOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation
import NHChainableOperations

protocol GetArtistAlbumsOperationDelegate: class {
  func getArtistAlbumsOperationDidFinish(_ albums: [Album])
}

class GetArtistAlbumsOperation: ChainableOperation<String, [Album]> {
  
  let requestManager = RequestManager()
  weak var delegate:  GetArtistAlbumsOperationDelegate?
  
  init(delegate: GetArtistAlbumsOperationDelegate) {
    self.delegate = delegate
  }
  
  override func main(_ input: String) {
    let urlString = "https://api.spotify.com/v1/artists/\(input)/albums"
    guard let url = URL(string: urlString) else {
      finish(.failure(GetArtistAlbumsOperationError.invalidURL))
      return
    }
    let request = URLRequest(url: url)
    requestManager.performRequest(request) { [weak self] result in
      switch result {
      case .success(let responseDictionary):
        guard let albumArray = responseDictionary["items"] as? [[String: AnyObject]] else {
          self?.finish(.failure(GetArtistAlbumsOperationError.invalidJSON))
          return
        }
        let albums = albumArray.flatMap { Album(dictionary: $0) }
        Thread.executeOnMain {
          self?.delegate?.getArtistAlbumsOperationDidFinish(albums)
        }
        self?.finish(.success(albums))
      case .failure(let error):
        self?.finish(.failure(error))
      }
    }
  }
}

enum GetArtistAlbumsOperationError: Error {
  case invalidURL
  case invalidJSON
}
