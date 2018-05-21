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

class AddExperienceViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let editProfile = StudentEditProfileViewController()
    let refPending = Database.database().reference().child("student").child("pending").child(Auth.auth().currentUser!.uid).child("experience")
    let refValid = Database.database().reference().child("student").child("valid").child(Auth.auth().currentUser!.uid).child("experience")
    let refCheckValid = Database.database().reference().child("student").child("valid")
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var jobCompany: UITextField!
    @IBOutlet var jobFromDate: UITextField!
    @IBOutlet var jobToDate: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: AddExperienceControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        jobCompany.delegate = self
        jobFromDate.delegate = self
        jobToDate.delegate = self

        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
        
        guard let jobTitle = jobTitle.text, !jobTitle.isEmpty, let jobCompany = jobCompany.text, !jobCompany.isEmpty, let jobFromDate = jobFromDate.text, !jobFromDate.isEmpty, let jobToDate = jobToDate.text, !jobToDate.isEmpty else {
            
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
        
        let ex = Experience(data: ["Title": self.jobTitle.text!, "Company": self.jobCompany.text!, "From Date": self.jobFromDate.text!, "To Date": self.jobToDate.text!])
        delegate?.didAddExperience(ex)
        self.navigationController?.popViewController(animated: true)
        
        refCheckValid.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                self.refValid.childByAutoId().setValue(ex.toDict())
                
            } else {
                
                self.refPending.childByAutoId().setValue(ex.toDict())
                
            }
            
        }
        
    }
    
}
