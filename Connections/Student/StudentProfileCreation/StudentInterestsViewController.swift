//
//  StudentInterestsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 25/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StudentInterestsViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var interestOne: UITextField!
    @IBOutlet var interestTwo: UITextField!
    @IBOutlet var interestThree: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestOne.delegate = self
        interestTwo.delegate = self
        interestThree.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func confirmBtn(_ sender: Any) {
        
        guard let interestOne = interestOne.text, !interestOne.isEmpty, let interestTwo = interestTwo.text, !interestTwo.isEmpty, let interestThree = interestThree.text, !interestThree.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            self.validationAlert.textColor = UIColor.red
            
            return
            
        }
   
        ref.updateChildValues(["Interest One": self.interestOne.text!, "Interest Two": self.interestTwo.text!, "Interest Three": self.interestThree.text!])
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
   
}


