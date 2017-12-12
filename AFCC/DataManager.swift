//
//  DataManager.swift
//  AFCC
//
//  Created by student on 4/2/17.
//  Copyright © 2017 Mariya Eggensperger. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper

//URL Firebase FIRDatabase
let BASE = FIRDatabase.database().reference()

// URL Firebase FIRStorage
let STORAGE = FIRStorage.storage().reference()

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
   
   var REF_BASE: FIRDatabaseReference {
      return _REF_BASE
   }
   
   var REF_POSTS: FIRDatabaseReference {
      return _REF_POSTS
   }
   
   var REF_USERS: FIRDatabaseReference {
      return _REF_USERS
   }
   
   var REF_USER_CURRENT: FIRDatabaseReference {
      let uid = KeychainWrapper.standard.string(forKey: "uid")
      let user = REF_USERS.child(uid!)
      return user
   
   }
   
   var REF_PROFILE_IMAGES: FIRStorageReference {
      return _REF_PROFILE_IMAGES
   }
   
   var REF_POSTS_IMAGES: FIRStorageReference {
      return _REF_POSTS_IMAGES
   }
   
   func createFirebaseDBUser(uid: String, userData: [String: String]) {
      // Users have unique identifiers
      REF_USERS.child(uid).updateChildValues(userData)
   }
}
