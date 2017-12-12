//
//  FeedViewController.swift
//  AFCC
//
//  Created by student on 4/7/17.
//  Copyright © 2017 Mariya Eggensperger. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeyChainWrapper

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

   // MARK - Outlets
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
   
   var posts = [Post]()
   static var imageCache = NSCache<NSString, UIImage>()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //self-sizing cell
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 190
      
      // observing for any changes in the posts object in firebase
      DatabaseManager.shared.REF_POSTS.observe(FIRDataEventType.value, with: { (snapshot) in
         // need to clear out the posts array when the app is interacted with otherwise posts will be duplicated from redownloading
         self.posts = []
         // going through every snapshot
         if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            //for every snap in the snapshot
            for snap in snapshot {
               // setting the value of each snap as a postDict
               if let postDict = snap.value as? [String: AnyObject] {
                  //setting constants of id and post
                  let id = snap.key
                  let post = Post(postID: id, postData: postDict)
                  //adding each post to the posts array
                  self.posts.append(post)
                  
               }
            }
            self.tableView.reloadData()
         }
         self.activeIndicator.stopAnimating()
      })
   }
   
   @IBAction func signOut(_ sender: UIBarButtonItem) {
      let keychainResult = KeychainWrapper.standard.removeObject(forKey: "uid")
      print("ID remove from Keychain \(keychainResult)")
      performSegue(withIdentifier: "toAuth", sender: nil)
   }
   
   //MARK: - UITableViewDataSource
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return posts.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // grabbing each post out of the posts array
      let post = posts[indexPath.row]
      
      // setting up each cell and calling configureCell which will update the UI with firebase data
      if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? PostCell {
         // let img equal to the imageCache with this specifiv post url
         if let img = FeedViewController.imageCache.object(forKey: post.imageURL as NSString) {
            cell.configureCell(post: post, imagePost: img)
            // pass that into the configure cell with the post itself
         } else {
            cell.configureCell(post: post)
         }
         return cell
      } else {
         return PostCell()
      }
      
   }
}
