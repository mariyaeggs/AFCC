/* <--SignInViewController.swift-->
 *
 * Arcadia Friends Community Church
 *
 * SignIn view to login users of the AFCC
 * iOS Application, providing mobile services
 * to a non-profit, religious community.
 *
 * @author Mariya Eggensperger
 */

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper


class SignInViewController: UIViewController {
   
   // MARK: Outlets
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   
   // MARK: Actions
   @IBAction func signInAction(_sender: UIButton) {
      if self.emailTextField.text == "" || self.passwordTextField.text == "" {
         let alertController = UIAlertController(title: "Error", message: "Enter email and password.", preferredStyle: .alert)
         
         let mainAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
         alertController.addAction(mainAction)
         
         self.present(alertController, animated: true, completion: nil)
         
      } else {
         Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            
            if error == nil {
               
               //Print into the console if successfully logged in
               print("Successfully logged in!")
               if let user = user {
                  let userData = ["provider": user.providerID]
                  self.completeSignIn(user.uid, userData)
                  
                  //Go to the HomeViewController if the login is sucessful
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                  self.present(vc!, animated: true, completion: nil)
               }
               
            } else {
               Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                  if error == nil {
                     print("Successfully authenticated with Firebase")
                     if let user = user {
                        let userData = ["provider": user.providerID,
                                        "profile-pic": "https://firebasestorage.googleapis.com/v0/b/afcc-5c471.appspot.com/o/profile-pics%2Fdefault-pic.jpg?alt=media&token=69586a60-8d4d-41f0-b309-1b511eaab2c8"
                        ]
                        
                        self.completeSignIn(user.uid, userData)
                        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                        
                     }
                  } else {
                     // Catch error and allow firebase to alert
                     let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                     
                     let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                     alertController.addAction(defaultAction)
                     
                     self.present(alertController, animated: true, completion: nil)
                     print("Unable to authenticate with Firebase using email")
                  }
               })
            }
         }
      }
   }
   func completeSignIn(_ id: String, _ userData: [String: String]) {
      DataManager.shared.createFirebaseDBUser(uid: id, userData: userData)
      let keycahinResult = KeychainWrapper.standard.set(id, forKey: "uid")
      print("Data save to Keychain \(keycahinResult)")
   }
   
}


