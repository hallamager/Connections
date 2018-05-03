//
//  AddJobsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 02/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddJobsControllerDelegate: class {
    func didAddJobs(_ job: Job)
}

class AddJobsViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid).child("Jobs")
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var employmentType: UITextField!
    @IBOutlet var jobDescription: UITextView!
    @IBOutlet var jobLocation: UITextField!
    @IBOutlet var jobSalary: UITextField!
    @IBOutlet var skillsRequired: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var validationAlert: UILabel!
    
    var skillRequired = [String]()
    
    weak var delegate: AddJobsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        employmentType.delegate = self
        jobLocation.delegate = self
        jobSalary.delegate = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillsRequired(_ sender: Any) {
        
        skillRequired.append(skillsRequired.text!)
        print(skillRequired)
        collectionView.reloadData()
        
        skillsRequired.text! = ""
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty, let jobDescription = jobDescription.text, !jobDescription.isEmpty, let employmentType = employmentType.text, !employmentType.isEmpty, let jobLocation = jobLocation.text, !jobLocation.isEmpty, let jobSalary = jobSalary.text, !jobSalary.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            return
            
        }
        
        ref.childByAutoId().setValue(["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!, "Location": self.jobLocation.text!, "Salary": self.jobSalary.text!, "skillsRequired": arrayToDict(array: skillRequired)])
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func arrayToDict(array: [String]) -> [String: Bool] {
        var dict = [String: Bool]()
        for item in array {
            dict[item] = true
        }
        return dict
    }
    
}
