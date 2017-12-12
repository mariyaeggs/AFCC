/* <--DirectoryTableViewController.swift-->
 *
 * Arcadia Friends Community Church
 *
 * View to present directory of users for
 * the AFCC iOS Application, providing mobile
 * services to a non-profit, religious community.
 *
 * @author Mariya Eggensperger
 */


import UIKit
import Firebase
import FirebaseDatabase

class DirectoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   var ref: DatabaseReference!
   let cellID = "Cell"
   private var refHandle: DatabaseHandle!
   var userList = [Users]()
   
   @IBOutlet weak var userTable: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      //Set firebase database reference
      ref = Database.database().reference()
      self.userTable.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
      fetchUserData { (success) in
         OperationQueue.main.addOperation ({
            
         })
      }
      
   }
   //Retrieve posts and listen for changes
   func fetchUserData(with completion:@escaping (Bool)->()) {
      refHandle = ref?.child("users").observe(.childAdded, with: { (snapshot) in
         //Code that executes when child is added
         if (snapshot.value as? [String: AnyObject]) != nil {
            let user = Users()
            user.name = snapshot.childSnapshot(forPath: "name").value as? String
            print(user.name)
            DispatchQueue.main.async{
               user.email = snapshot.childSnapshot(forPath: "email").value as? String
               print(user.email)
               print("databaseHandle was called")
               for user in self.userList {
                  print(user)
                  self.userList.append(user)
                  self.do_table_refresh()
               }
               
               
            }
            
         }
         completion(true)
      })
   }
   func do_table_refresh() {
      DispatchQueue.main.async(execute: {
        self.userTable.reloadData()
         return
      })
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 2
   }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return userList.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
      cell.textLabel?.text = userList[indexPath.row].name.self
      cell.textLabel?.text = userList[indexPath.row].email.self
      return cell
      
   }
}
