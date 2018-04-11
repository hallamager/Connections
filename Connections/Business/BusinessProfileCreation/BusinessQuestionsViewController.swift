//
//  BusinessQuestionsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 15/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessQuestionsViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var questionOne: UITextField!
    @IBOutlet var questionTwo: UITextField!
    @IBOutlet var questionThree: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionOne.delegate = self
        questionTwo.delegate = self
        questionThree.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmButtom(_ sender: Any) {
        
        ref.updateChildValues(["Question One": self.questionOne.text!, "Question Two": self.questionTwo.text!, "Question Three": self.questionThree.text!])
        
        self.presentBusinessProfileCreationViewController()

    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
