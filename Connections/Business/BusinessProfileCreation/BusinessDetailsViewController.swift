//
//  BusinessDetailsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessDetailsViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var companyWebsite: UITextField!
    @IBOutlet var companySize: UITextField!
    @IBOutlet var companyHeadquaters: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyWebsite.delegate = self
        companySize.delegate = self
        companyHeadquaters.delegate = self
        
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
        
        ref.updateChildValues(["Website": self.companyWebsite.text!, "Company Size": self.companySize.text!, "Headquarters": self.companyHeadquaters.text!])
        
        self.presentBusinessProfileCreationViewController()
        
    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
