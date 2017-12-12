/* <--HomeViewController.swift-->
 *
 * Arcadia Friends Community Church
 *
 * Home view for the AFCC iOS Application, 
 * providing mobile services to a non-profit, 
 * religious community. 
 *
 * @author Mariya Eggensperger
 */

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
   
   @IBAction func logoutAction(_sender: AnyObject) {
      if Auth.auth().currentUser != nil {
         do {
            try Auth.auth().signOut()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController")
            present(vc, animated: true, completion: nil)
            
         } catch let error as NSError {
            print(error.localizedDescription)
         }
      }
   }
}
