//
//  EditEducationViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol EditEducationControllerDelegate: class {
    func didEditEducation(_ education: Education)
}

class EditEducationViewController: UIViewController, UITextFieldDelegate {
    
    var education: Education!
    var educations = [Education]()
    
    @IBOutlet var school: UITextField!
    @IBOutlet var qType: UITextField!
    @IBOutlet var studied: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: EditEducationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        school.delegate = self
        qType.delegate = self
        studied.delegate = self
        
        school.text = education.school
        qType.text = education.qType
        studied.text = education.studied
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        
        let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education").child(education.uuid!)
        
        let ex = Education(data: ["School": self.school.text!, "Qualification Type": self.qType.text!, "Studied": self.studied.text!])
        
        ref.updateChildValues(ex.toDict())
        
        delegate?.didEditEducation(ex)
        self.navigationController?.popViewController(animated: true)

    }
    
}
