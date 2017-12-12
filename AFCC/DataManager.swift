//
//  DataManager.swift
//  AFCC
//
//  Created by Mariya Eggensperger on 4/2/17.
//  Copyright © 2017 Mariya Eggensperger. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper

//URL Firebase FIRDatabase
let BASE = Database.database().reference()

// URL Firebase FIRStorage
let STORAGE = Storage.storage().reference()

class DataManager {
   //Singleton
   static let shared = DataManager()
   
   //Database references
   private var _REF_BASE = BASE
   private var _REF_POSTS = BASE.child("posts")
   private var _REF_USERS = BASE.child("users")
   
   //Storage references
   private var _REF_POSTS_IMAGES = STORAGE.child("post-pics")
   private var _REF_PROFILE_IMAGES = STORAGE.child("profile-pics")
   
   var REF_BASE: DatabaseReference {
      return _REF_BASE
   }
   
   var REF_POSTS: DatabaseReference {
      return _REF_POSTS
   }
   
   var REF_USERS: DatabaseReference {
      return _REF_USERS
   }
   var REF_USER_CURRENT: DatabaseReference? {
      let uid = KeychainWrapper.standard.string(forKey: "uid")
         let user = REF_USERS.child(uid!)
         return user
   }
   var REF_PROFILE_IMAGES: StorageReference {
      return _REF_PROFILE_IMAGES
   }

   var REF_POSTS_IMAGES: StorageReference {
      return _REF_POSTS_IMAGES
   }

   func createFirebaseDBUser(uid: String, userData: [String: String]) {
      // Users have unique identifiers
      REF_USERS.child(uid).updateChildValues(userData)
   }
}
