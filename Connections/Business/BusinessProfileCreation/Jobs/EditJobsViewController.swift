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

protocol EditJobControllerDelegate: class {
    func didEditJob(_ job: Job)
}

class EditJobsViewController: UIViewController, UITextFieldDelegate {
    
    var job: Job!
    var jobs = [Job]()
    var skillRequired = [String]()
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var employmentType: UITextField!
    @IBOutlet var jobDescription: UITextView!
    @IBOutlet var jobLocation: UITextField!
    @IBOutlet var jobSalary: UITextField!
    @IBOutlet weak var editRequiredSkill: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: EditJobControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        jobTitle.delegate = self
        employmentType.delegate = self
        jobLocation.delegate = self
        jobSalary.delegate = self
        
        jobTitle.text = job.title
        employmentType.text = job.employmentType
        jobDescription.text = job.description
        jobLocation.text = job.location
        jobSalary.text = job.salary
        
        let refSkillsRequired = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!).child("skillsRequired")
        
        refSkillsRequired.observe(.value, with: { snapshot in
            
            self.skillRequired.removeAll()
            
            for group in snapshot.children {
                self.skillRequired.append((group as AnyObject).key)
            }
            print(self.skillRequired)
            
            self.collectionView.reloadData()
            
        })
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func editRequiredSkillBtn(_ sender: Any) {
        
        let refSkillsRequired = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!).child("skillsRequired")

        refSkillsRequired.updateChildValues([self.editRequiredSkill.text! : true])
        
        editRequiredSkill.text! = ""
        
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
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
        
        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty, let employmentType = employmentType.text, !employmentType.isEmpty, let jobDescription = jobDescription.text, !jobDescription.isEmpty, let jobLocation = jobLocation.text, !jobLocation.isEmpty, let jobSalary = jobSalary.text, !jobSalary.isEmpty else {
            
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
        
        let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!)
        
        ref.updateChildValues(["Title": self.jobTitle.text!, "Employment Type": self.employmentType.text!, "Description": self.jobDescription.text!, "Location": self.jobLocation.text!, "Salary": self.jobSalary.text!])
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension EditJobsViewController: DeleteSkillRequiredCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        
        if let indexPath = getCurrentCollectionCellIndexPath(sender) {
            
            if sender.tag == 1 {
                
                let skillsRequired = skillRequired[indexPath.row]
                
                let refDeleteSkillsRequired = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!).child("skillsRequired").child(skillsRequired)
                
                refDeleteSkillsRequired.removeValue()
                
            }
            
        }
        
    }
    
    func getCurrentCollectionCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath: IndexPath = collectionView.indexPathForItem(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
