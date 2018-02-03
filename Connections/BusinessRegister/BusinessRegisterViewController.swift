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

class BusinessRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        UIApplication.shared.statusBarStyle = .lightContent
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    //    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        // checking if the fields are not nil
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            let ref = Database.database().reference()
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if let firebaseError = error {
                    
                    print(firebaseError.localizedDescription)
                    return
                    
                } else {
                    
                    // following method is a add user's  more details
                    ref.child("business").child(user!.uid).setValue(["Company Name": self.companyNameTextField.text!, "type": "business"])
                    
                    ref.child("users").child(user!.uid).setValue(["type": "business"])

                }
                
            })
            
            self.presentBusinessProfileCreationViewController()
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentBusinessProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StudentSwipeViewController:StudentSwipeViewController = storyboard.instantiateViewController(withIdentifier: "StudentSwipeViewController") as! StudentSwipeViewController
        self.present(StudentSwipeViewController, animated: true, completion: nil)
    }
    
}
