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
    
    @IBOutlet var cultureOne: UITextField!
    @IBOutlet var cultureTwo: UITextField!
    @IBOutlet var cultureThree: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cultureOne.delegate = self
        cultureTwo.delegate = self
        cultureThree.delegate = self
        
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
        
        ref.updateChildValues(["CultureOne": self.cultureOne.text!, "cultureTwo": self.cultureTwo.text!, "cultureTwo": self.cultureThree.text!])
        
        self.presentBusinessProfileCreationViewController()
        
    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
