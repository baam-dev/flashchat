//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//
 
import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey"),
        Message(sender: "a@b.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "Sup? What are you up to? What are you up to?"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appName
        // hide back btn at chat screen
        navigationItem.hidesBackButton = true
        // registering the Nib file with this tableView
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //get hold of the message itself and the user email
        // Auth.auth() has other properties that will be useful later
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { error in
                if let e = error {
                    print("There was an issue saving data to firestore \(e)")
                    
                } else {
                    print("Successfully saved Data")
                }
            }
            
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        confirmLogout ()
        
        func confirmLogout () {
            let alert = UIAlertController(title: "Log Out", message: "You will be returned to the login screen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            }))
            alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: {action in
                // if user chose to log out, go to the first page
                // print the error if there is any
            do {
                try Auth.auth().signOut()
                // pop to root, goes directly to the login screen
                self.navigationController?.popToRootViewController(animated: true)
                
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
            }))
            self.present(alert, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // this meethod gets called for as many rows as there are in the table view so message.row times
        // using as keyword: cast this reusable cell as a MessageCell class 
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
 
        return cell
    }
    
    
}

