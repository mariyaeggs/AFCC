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

class SignInViewController: UIViewController {
   
   // MARK: Outlets
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   
   // MARK: Actions
   @IBAction func signInAction(_sender: AnyObject) {
      if self.emailTextField.text == "" || self.passwordTextField.text == "" {
         let alertController = UIAlertController(title: "Error", message: "Enter email and password.", preferredStyle: .alert)
         
         let mainAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
         alertController.addAction(mainAction)
         
         self.present(alertController, animated: true, completion: nil)
         
      } else {
         FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            
            if error == nil {
               
               //Print into the console if successfully logged in
               print("Successfully logged in!")
               
               //Go to the HomeViewController if the login is sucessful
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
               self.present(vc!, animated: true, completion: nil)
               
            } else {
               
               //Tells the user that there is an error and then gets firebase to tell them the error
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self.present(alertController, animated: true, completion: nil)
            }
         }
      }
   }
}


