//
//  StudentPersonalViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 04/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StudentPersonalViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var studentAddress: UITextField!
    @IBOutlet var studentHeadline: UITextField!
    @IBOutlet var studentSummary: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentAddress.delegate = self
        studentHeadline.delegate = self
        studentSummary.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
                
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
        
        guard let studentAddress = studentAddress.text, !studentAddress.isEmpty, let studentHeadline = studentHeadline.text, !studentHeadline.isEmpty, let studentSummary = studentSummary.text, !studentSummary.isEmpty else {
            
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
        
        ref.updateChildValues(["Address": self.studentAddress.text!, "Headline": self.studentHeadline.text!, "Summary": self.studentSummary.text!])
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
