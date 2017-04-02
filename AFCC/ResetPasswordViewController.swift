/* <--ResetPasswordViewController.swift-->
 *
 * Arcadia Friends Community Church
 *
 * View to reset password(s) for users of
 * the AFCC iOS Application, providing mobile
 * services to a non-profit, religious community.
 *
 * @author Mariya Eggensperger
 */

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
   
   // MARK: Outlets
   @IBOutlet weak var emailResetPassword: UITextField!
   
   // MARK: Actions
   @IBAction func resetPasswordAction(_sender: AnyObject) {
      if self.emailResetPassword.text == "" {
         let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
         
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         
         present(alertController, animated: true, completion: nil)
         
      } else {
         FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailResetPassword.text!, completion: { (error) in
            
            var title = ""
            var message = ""
            
            if error != nil {
               title = "Error!"
               message = (error?.localizedDescription)!
            } else {
               title = "Success!"
               message = "Password reset email sent."
               self.emailResetPassword.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
         })
      }
   }
}
