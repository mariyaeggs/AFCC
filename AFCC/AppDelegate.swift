/* <--AppDelegate.swift-->
 *
 * Arcadia Friends Community Church
 *
 * AppDelegate for users of the AFCC 
 * iOS Application, providing mobile
 * services to a non-profit, religious community.
 *
 * @author Mariya Eggensperger
 */

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      FirebaseApp.configure()
      
      return true
  }
}
