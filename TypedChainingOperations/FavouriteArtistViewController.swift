//
//  FavouriteArtistViewController.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 18/08/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit

protocol FavouriteArtistViewControllerDelegate: class {
  func favouriteArtistPicked(_ artistName: String)
}

final class FavouriteArtistViewController: UIViewController {
  weak var delegate: FavouriteArtistViewControllerDelegate?
  
  init(delegate: FavouriteArtistViewControllerDelegate) {
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func goPressed(_ sender: AnyObject) {
    delegate?.favouriteArtistPicked("08GQAI4eElDnROBrJRGE0X")
    dismiss(animated: true, completion: nil)
  }

}
