//
//  AddExperienceViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddExperienceControllerDelegate: class {
    func didAddExperience(_ experience: Experience)
}

class AddExperienceViewController: UIViewController, UITextFieldDelegate {
    
    
    let editProfile = StudentEditProfileViewController()
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("experience")
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var jobCompany: UITextField!
    @IBOutlet var jobCity: UITextField!
    @IBOutlet var jobFromDate: UITextField!
    @IBOutlet var jobToDate: UITextField!
    @IBOutlet var jobDescription: UITextView!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: AddExperienceControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        jobCompany.delegate = self
        jobCity.delegate = self
        jobFromDate.delegate = self
        jobToDate.delegate = self

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
        
        editProfile.tableView.reloadData()

        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty, let jobCompany = jobCompany.text, !jobCompany.isEmpty, let jobCity = jobCity.text, !jobCity.isEmpty, let jobFromDate = jobFromDate.text, !jobFromDate.isEmpty, let jobToDate = jobToDate.text, !jobToDate.isEmpty, let jobDescription = jobDescription.text, !jobDescription.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            return
            
        }
        
        let ex = Experience(data: ["Title": self.jobTitle.text!, "Company": self.jobCompany.text!, "Location": self.jobCity.text!, "From Date": self.jobFromDate.text!, "To Date": self.jobToDate.text!, "Description": self.jobDescription.text!])
        delegate?.didAddExperience(ex)
        self.navigationController?.popViewController(animated: true)
        ref.childByAutoId().setValue(ex.toDict())
        
    }
    
}
