//
//  EditJobsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 02/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditJobsViewController: UIViewController, UITextFieldDelegate {
    
    var job: Job!
    var jobs = [Job]()
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var employmentType: UITextField!
    @IBOutlet var jobDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        employmentType.delegate = self
        
        jobTitle.text = job.title
        employmentType.text = job.employmentType
        jobDescription.text = job.description
        
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
        
        let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!)
        
        ref.updateChildValues(["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!])
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ShowJobsAddedViewController:ShowJobsAddedViewController = storyboard.instantiateViewController(withIdentifier: "ShowJobsAddedViewController") as! ShowJobsAddedViewController
        self.present(ShowJobsAddedViewController, animated: true, completion: nil)
        
    }
    
}
