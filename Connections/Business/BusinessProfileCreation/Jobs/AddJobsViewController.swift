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
import IQKeyboardManagerSwift

protocol AddJobsControllerDelegate: class {
    func didAddJobs(_ job: Job)
}

class AddJobsViewController: UIViewController, UITextFieldDelegate {
    
    let refPending = Database.database().reference().child("business").child("pending").child(Auth.auth().currentUser!.uid).child("Jobs")
    let refValid = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid).child("Jobs")
    let refCheckValid = Database.database().reference().child("business").child("valid")
    
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
        
        skillsRequired.keyboardDistanceFromTextField = 105
        
        self.navigationController?.navigationBar.tintColor = UIColor.black

    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillsRequired(_ sender: Any) {
        
        skillRequired.append(skillsRequired.text!)
        print(skillRequired)
        print("skillRequired count\(skillRequired.count)")
        collectionView.reloadData()
        
        skillsRequired.text! = ""
        
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        if skillRequired.isEmpty {
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x - 10, y: self.validationAlert.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x + 10, y: self.validationAlert.center.y))
            
            self.validationAlert.layer.add(animation, forKey: "position")
            
            self.validationAlert.text! = "You must enter at least one skill required"
            
            return
        }
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty, let jobDescription = jobDescription.text, !jobDescription.isEmpty, let employmentType = employmentType.text, !employmentType.isEmpty, let jobLocation = jobLocation.text, !jobLocation.isEmpty, let jobSalary = jobSalary.text, !jobSalary.isEmpty else {
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x - 10, y: self.validationAlert.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x + 10, y: self.validationAlert.center.y))
            
            self.validationAlert.layer.add(animation, forKey: "position")
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            return
            
        }
        
        refCheckValid.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                self.refValid.childByAutoId().setValue(["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!, "Location": self.jobLocation.text!, "Salary": self.jobSalary.text!, "skillsRequired": self.arrayToDict(array: self.skillRequired)])
                
            } else {
                
                self.refPending.childByAutoId().setValue(["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!, "Location": self.jobLocation.text!, "Salary": self.jobSalary.text!, "skillsRequired": self.arrayToDict(array: self.skillRequired)])
                
            }
            
        }
        
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
