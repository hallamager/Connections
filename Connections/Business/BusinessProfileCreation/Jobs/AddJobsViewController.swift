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
    
    weak var delegate: AddJobsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        jobTitle.delegate = self
        employmentType.delegate = self
        
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
        
        let ex = Job(data: ["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!])
        delegate?.didAddJobs(ex)
        ref.childByAutoId().setValue(ex.toDict())
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
