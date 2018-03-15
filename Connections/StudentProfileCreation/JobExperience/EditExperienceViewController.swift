//
//  EditExperienceViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 21/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditExperienceViewController: UIViewController, UITextFieldDelegate {
    
    var experience: Experience!
    var experiences = [Experience]()
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var jobCompany: UITextField!
    @IBOutlet var jobCity: UITextField!
    @IBOutlet var jobFromDate: UITextField!
    @IBOutlet var jobToDate: UITextField!
    @IBOutlet var jobDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        jobCompany.delegate = self
        jobCity.delegate = self
        jobFromDate.delegate = self
        jobToDate.delegate = self
        
        jobTitle.text = experience.title
        jobCompany.text = experience.company
        jobCity.text = experience.location
        jobFromDate.text = experience.fromDate
        jobToDate.text = experience.toDate
        jobDescription.text = experience.description
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience").child(experience.uuid!)
        
        ref.updateChildValues(["Title": self.jobTitle.text!, "Company": self.jobCompany.text!, "Location": self.jobCity.text!, "From Date": self.jobFromDate.text!, "To Date": self.jobToDate.text!, "Description": self.jobDescription.text!])
        
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
        let ShowExperienceAddedViewController:ShowExperienceAddedViewController = storyboard.instantiateViewController(withIdentifier: "ShowExperienceAddedViewController") as! ShowExperienceAddedViewController
        self.present(ShowExperienceAddedViewController, animated: true, completion: nil)
        
    }
    
}
