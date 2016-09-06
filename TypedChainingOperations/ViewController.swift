//
//  ViewController.swift
//  TypedChainingOperations
//
//  Created by Neil Horton on 10/07/2016.
//  Copyright © 2016 theappbusiness. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let operationQueue = NSOperationQueue()
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
  func getArtistAlbumsOperationDidFinish(albums: [Album]) {
    self.albums = albums
    tableView.reloadData()
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(AlbumTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? AlbumTableViewCell else {
      fatalError()
    }
    cell.albumNameLabel.text = albums[indexPath.row].name
    return cell
  }
}

