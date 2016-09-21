//
//  ViewController.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit
import NHChainableOperations

class ViewController: UIViewController {
  
  let operationQueue = OperationQueue()
  var albums: [Album] = []

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let operationChain =  GetUsersFavouriteArtistOperation(presentationContext: self)
                          ==> GetArtistAlbumsOperation(delegate: self)
                          ==> SaveFavouriteAlbumsOperation()
    
    operationQueue.addOperationChain(operationChain)
  }
}

extension ViewController: GetArtistAlbumsOperationDelegate {
  func getArtistAlbumsOperationDidFinish(_ albums: [Album]) {
    self.albums = albums
    tableView.reloadData()
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseIdentifier, for: indexPath) as? AlbumTableViewCell else {
      fatalError()
    }
    cell.albumNameLabel.text = albums[(indexPath as NSIndexPath).row].name
    return cell
  }
}

