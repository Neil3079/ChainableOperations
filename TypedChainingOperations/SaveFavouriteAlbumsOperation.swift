//
//  SaveFavouriteAlbumsOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import Foundation

class SaveFavouriteAlbumsOperation: ChainableOperation<[Album], Void> {
  
  let keyValueService = KeyValueService()
  
  override func main(_ input: [Album]) {
    keyValueService.storeArrayForKey(input, key: .FavouriteAlbums)
    finish(.success())
  }
  
}
