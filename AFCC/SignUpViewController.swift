/* <--SignUpViewController.swift-->
 *
 * Arcadia Friends Community Church
 *
 * SignUp view to register users for the AFCC
 * iOS Application, providing mobile services
 * to a non-profit,religious community.
 *
 * @author Mariya Eggensperger
 */

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   // MARK: Outlets
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var profileImageView: UIImageView!
   
   // Rounded user image upload
   override func viewDidLoad() {
      super.viewDidLoad()
      profileImageView.layer.cornerRadius =
         profileImageView.frame.size.width/2
      profileImageView.clipsToBounds = true
      
   }
   
   // MARK: Actions
   @IBAction func signUpAction(_sender: AnyObject) {
      // If the user does not input email/password
      if emailTextField.text == "" {
         // Show alert and request for email/password
         let alertController = UIAlertController(title: "Error", message: "Enter email and password.", preferredStyle: .alert)
         
         let mainAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
         alertController.addAction(mainAction)
         
         present(alertController, animated: true, completion: nil)
      }
      else {
         FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error == nil {
               print("Successfully signed up!")
               //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
               self.present(vc!, animated: true, completion: nil)
               
            } else {
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self.present(alertController, animated: true, completion: nil)
            }
         }
      }
      
   }
}


