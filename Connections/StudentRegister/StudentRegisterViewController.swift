//
//  StudentRegisterViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import GeoFire

class StudentRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        
        if confirmPasswordTextField.text == passwordTextField.text {
            confirmPasswordImage.image = #imageLiteral(resourceName: "Ok")
        } else {
            confirmPasswordImage.image = #imageLiteral(resourceName: "NotOk")
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        guard passwordTextField.text! == confirmPasswordTextField.text! else {
            
            print("Passwords dont match")
            
            return
            
        }
        
        // checking if the fields are not nil
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            let ref = Database.database().reference()
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if let firebaseError = error {
                    
                    print(firebaseError.localizedDescription)
                    return
                    
                } else {
                    
                    // following method is a add user's more details
                    ref.child("student").child(user!.uid).updateChildValues(["Username": self.usernameTextField.text!, "type": "student"])
                    
                    ref.child("users").child(user!.uid).setValue(["type": "student"])
                    
                }
                
            })
            
//            self.presentStudentProfileCreationViewController()
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentStudentProfileCreationViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileCreationNavigation")
        self.present(vc!, animated: true, completion: nil)
    }
    

}

