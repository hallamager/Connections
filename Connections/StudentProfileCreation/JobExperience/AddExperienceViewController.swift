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
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("experience")
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var jobCompany: UITextField!
    @IBOutlet var jobCity: UITextField!
    @IBOutlet var jobFromDate: UITextField!
    @IBOutlet var jobToDate: UITextField!
    @IBOutlet var jobDescription: UITextField!
    
    weak var delegate: AddExperienceControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        jobCompany.delegate = self
        jobCity.delegate = self
        jobFromDate.delegate = self
        jobToDate.delegate = self
        jobDescription.delegate = self

    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        let ex = Experience(data: ["Title": self.jobTitle.text!, "Company": self.jobCompany.text!, "Location": self.jobCity.text!, "From Date": self.jobFromDate.text!, "To Date": self.jobToDate.text!, "Description": self.jobDescription.text!])
//        delegate?.didAddExperience(ex)
//        dismiss(animated: true, completion: nil)
        ref.childByAutoId().setValue(ex.toDict())
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ShowExperienceAddedViewController:ShowExperienceAddedViewController = storyboard.instantiateViewController(withIdentifier: "ShowExperienceAddedViewController") as! ShowExperienceAddedViewController
        self.present(ShowExperienceAddedViewController, animated: true, completion: nil)
                
    }
    
}
