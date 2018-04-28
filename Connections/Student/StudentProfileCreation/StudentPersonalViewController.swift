//
//  StudentPersonalViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 04/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StudentPersonalViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var studentAddress: UITextField!
    @IBOutlet var studentHeadline: UITextField!
    @IBOutlet var studentSummary: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentAddress.delegate = self
        studentHeadline.delegate = self
        studentSummary.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
                
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        guard let studentAddress = studentAddress.text, !studentAddress.isEmpty, let studentHeadline = studentHeadline.text, !studentHeadline.isEmpty, let studentSummary = studentSummary.text, !studentSummary.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            return
            
        }
        
        ref.updateChildValues(["Address": self.studentAddress.text!, "Headline": self.studentHeadline.text!, "Summary": self.studentSummary.text!])
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
