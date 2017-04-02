//
//  AppDelegate.swift
//  AFCC
//
//  Created by student on 4/1/17.
//  Copyright © 2017 Mariya Eggensperger. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      FIRApp.configure()
      
      return true
   }

}

