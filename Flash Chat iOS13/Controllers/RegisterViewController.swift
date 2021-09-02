//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    // in case there was an error, here you can create an alert message
                    let errorMsg = e.localizedDescription
                    showAlert()
                    
                    // show the alert to user, message comes from firebase
                    // the error is related either to password or email
                    func showAlert() {
                        let alert = UIAlertController(title: "Alert!", message: "\(errorMsg)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
                        }))
                        self.present(alert, animated: true)
                    }
                } else {
                    // if there is no error then a can get hold of users data
                    // or more actions like navigate to ChatViewController
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    print(email, password)
                }
            }
        }
    }

    
}
