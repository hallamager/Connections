//
//  BusinessAboutViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 04/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessAboutViewController: UIViewController, UITextFieldDelegate {
    
    var business: Business!
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)

    @IBOutlet var companyIndustry: UITextField!
    @IBOutlet var companyDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        companyIndustry.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmAbout(_ sender: Any) {
        
        ref.updateChildValues(["Industry": self.companyIndustry.text!, "Description": self.companyDescription.text!])
        
        self.presentBusinessProfileCreationViewController()
        
    }
    
    
    func presentBusinessProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessCreateProfileLandingViewController:BusinessCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "BusinessCreateProfileLandingViewController") as! BusinessCreateProfileLandingViewController
        self.present(BusinessCreateProfileLandingViewController, animated: true, completion: nil)
    }
    
}
