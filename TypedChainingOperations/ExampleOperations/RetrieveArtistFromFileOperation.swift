//
//  RetrieveArtistFromFileOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit

class GetUsersFavouriteArtistOperation: ChainableOperation<Void, String> {
  
  let presentationContext: UIViewController
  
  init(presentationContext: UIViewController) {
    self.presentationContext = presentationContext
  }
  
  override func main(input: Void) {
    let favouriteArtistVC = FavouriteArtistViewController(delegate: self)
    presentationContext.presentViewController(favouriteArtistVC, animated: true, completion: nil)
  }
}

extension GetUsersFavouriteArtistOperation: FavouriteArtistViewControllerDelegate {
  func favouriteArtistPicked(artistName: String) {
    finish(.Success(artistName))
  }
}