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
   
   var imagePicker: UIImagePickerController!
   var isImageSelected = false
   
   // MARK: Outlets
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var profileImageView: UIImageView!
   @IBOutlet weak var phoneTextField: UITextField!
   @IBOutlet weak var addressTextField: UITextField!
   
   // Additional setup after loading the view
   override func viewDidLoad() {
      super.viewDidLoad()
      // Rounded rect images
      profileImageView.layer.cornerRadius =
         profileImageView.frame.size.width/2
      profileImageView.clipsToBounds = true
      
      nameTextField.delegate = self;
      imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      
      
   }
   
   // MARK: Actions
   @IBAction func signUpAction(_sender: AnyObject) {
      guard let nameField = nameTextField.text, nameField != "" else {
         print("Enter name.")
         return
      }
      
      // Select an image from iPhoto
      guard let img = profileImageView.image,
         isImageSelected == true
         else {
            print("Select an image.")
            return
      }
      guard let phoneField = phoneTextField.text, phoneField != "" else {
         print("Enter phone.")
         return
      }
      guard let addressField = addressTextField.text, addressField != "" else {
         print("Enter address.")
         return
      }
      
      // If the user does not input email/password
      if emailTextField.text == "" {
         // Show alert and request for email/password
         let alertController = UIAlertController(title: "Error", message: "Enter email and password.", preferredStyle: .alert)
         
         let mainAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
         alertController.addAction(mainAction)
         
         present(alertController, animated: true, completion: nil)
      }
      else {
         Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error == nil {
               print("Successfully signed up!")
               //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
               self.present(vc!, animated: true, completion: nil)
               
            } else {
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let mainAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
               alertController.addAction(mainAction)
               
               self.present(alertController, animated: true, completion: nil)
            }
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
               // Set unique identifier
               let imgUid = NSUUID().uuidString
               // Format to image.jpeg
               let metaData = StorageMetadata()
               metaData.contentType = "image/jpeg"
               // Re Firebase storage child with the unique identifier, and updating with the image from the picker
               DataManager.shared.REF_PROFILE_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadata, error) in
                  if error != nil {
                     print("Unable to upload image Firebase storage")
                  } else {
                     print("Successfully uploaded image to Firebase storage")
                     let downloadUrl = metadata?.downloadURL()?.absoluteString
                     if let url = downloadUrl {
                        //once the image is uploaded to firebase stoarge, its then posted to the database
                        self.postToFirebase(imgUrl: url)
                     }
                  }
               })
               
               
            }
         }
         
      }
   }
   func postToFirebase(imgUrl: String) {
      // Set users child values
      let userInfo: Dictionary<String, Any> = [
         "name" : nameTextField.text!,
         "email": emailTextField.text!,
         "phone": phoneTextField.text!,
         "address": addressTextField.text!,
         "profile-pic" : imgUrl
      ]
      
      // Update db with new information
      DataManager.shared.REF_USER_CURRENT?.updateChildValues(userInfo)
      
      // Reset fields
      nameTextField.text = ""
      isImageSelected = false
      
      
      profileImageView.image = UIImage(named: "default-pic")
   }
   
   
   @IBAction func profilePicTapped(_ sender: AnyObject) {
      present(imagePicker, animated: true, completion: nil)
   }
   
   // Mark: UIImagePickerControllerDelegate
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
         profileImageView.image = img
         isImageSelected = true
      } else {
         print ("Invalid image selected.")
      }
      imagePicker.dismiss(animated: true, completion: nil)
   }
   // Mark: UITextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true)
      return true
   }
   
}


