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
    @IBOutlet weak var validationAlert: UILabel!
    
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
        
        guard let questionOne = questionOne.text, !questionOne.isEmpty, let questionTwo = questionTwo.text, !questionTwo.isEmpty, let questionThree = questionThree.text, !questionThree.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            self.validationAlert.textColor = UIColor.red
            
            return
            
        }
        
        ref.updateChildValues(["Question One": self.questionOne.text!, "Question Two": self.questionTwo.text!, "Question Three": self.questionThree.text!])
        
        self.presentBusinessProfileCreationViewController()

    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
