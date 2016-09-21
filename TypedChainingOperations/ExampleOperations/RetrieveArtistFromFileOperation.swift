//
//  RetrieveArtistFromFileOperation.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit
import NHChainableOperations

class GetUsersFavouriteArtistOperation: ChainableOperation<Void, String> {
  
  let presentationContext: UIViewController
  
  init(presentationContext: UIViewController) {
    self.presentationContext = presentationContext
  }
  
  override func main(_ input: Void) {
    let favouriteArtistVC = FavouriteArtistViewController(delegate: self)
    presentationContext.present(favouriteArtistVC, animated: true, completion: nil)
  }
}

extension GetUsersFavouriteArtistOperation: FavouriteArtistViewControllerDelegate {
  func favouriteArtistPicked(_ artistName: String) {
    finish(.success(artistName))
  }
}
