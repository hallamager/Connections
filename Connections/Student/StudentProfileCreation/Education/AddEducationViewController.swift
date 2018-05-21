//
//  AddEducationViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddEducationControllerDelegate: class {
    func didAddEducation(_ education: Education)
}

class AddEducationViewController: UIViewController, UITextFieldDelegate {
    
    let editProfile = StudentEditProfileViewController()
    let refPending = Database.database().reference().child("student").child("pending").child(Auth.auth().currentUser!.uid).child("education")
    let refValid = Database.database().reference().child("student").child("valid").child(Auth.auth().currentUser!.uid).child("education")
    let refCheckValid = Database.database().reference().child("student").child("valid")
    
    @IBOutlet var school: UITextField!
    @IBOutlet var qType: UITextField!
    @IBOutlet var studied: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: AddEducationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        school.delegate = self
        qType.delegate = self
        studied.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
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
                
        guard let school = school.text, !school.isEmpty, let qType = qType.text, !qType.isEmpty, let studied = studied.text, !studied.isEmpty else {
            
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
        
        let ex = Education(data: ["School": self.school.text!, "Qualification Type": self.qType.text!, "Studied": self.studied.text!])
        delegate?.didAddEducation(ex)
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
