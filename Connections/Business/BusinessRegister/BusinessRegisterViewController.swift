//
//  BusinessRegisterViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 31/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GeoFire

class BusinessRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        
        if confirmPasswordTextField.text == passwordTextField.text {
            confirmPasswordImage.image = #imageLiteral(resourceName: "Ok")
        } else {
            confirmPasswordImage.image = #imageLiteral(resourceName: "NotOk")
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func alreadyHaveAnAccountBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
            
        let ref = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if let firebaseError = error {
                
                print(firebaseError.localizedDescription)
                return
                
            } else {
                
                // following method is a add user's more details
                ref.child("business").child(user!.uid).updateChildValues(["Company Name": self.companyNameTextField.text!, "type": "business"])
                
                ref.child("users").child(user!.uid).setValue(["type": "business"])

                self.presentBusinessProfileCreationViewController()

            }
            
        })
            
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentBusinessProfileCreationViewController() {
        let storyboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BusinessCreateProfile")
        self.present(viewController, animated: true)
    }
    
}
