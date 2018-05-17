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

class StudentPersonalViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let refPending = Database.database().reference().child("student").child("pending").child(Auth.auth().currentUser!.uid)
    let refValid = Database.database().reference().child("student").child("valid").child(Auth.auth().currentUser!.uid)
    let refCheckValid = Database.database().reference().child("student").child("valid")
    
    @IBOutlet var studentAddress: UITextField!
    @IBOutlet var studentHeadline: UITextField!
    @IBOutlet var studentSummary: UITextView!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentAddress.delegate = self
        studentHeadline.delegate = self
        studentSummary.delegate = self
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                print("hello valid")
                
                self.refValid.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.hasChild("Summary") && snapshot.hasChild("Headline") && snapshot.hasChild("Address"){
                        
                        if let student = Student(snapshot: snapshot) {
                            self.studentAddress.text = student.address
                            self.studentHeadline.text = student.headline
                            self.studentSummary.text = student.summary
                        }
                        
                    }
                }
                
            } else {
                
                print("hello pending")
                
                self.refPending.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.hasChild("Summary") && snapshot.hasChild("Headline") && snapshot.hasChild("Address"){
                        
                        if let student = Student(snapshot: snapshot) {
                            self.studentAddress.text = student.address
                            self.studentHeadline.text = student.headline
                            self.studentSummary.text = student.summary
                        }
                        
                    }
                }
                
            }
            
        })
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
                
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
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                print("hello valid")
                
                self.refValid.updateChildValues(["Address": self.studentAddress.text!, "Headline": self.studentHeadline.text!, "Summary": self.studentSummary.text!])
                
            } else {
                
                print("hello pending")
                
                self.refPending.updateChildValues(["Address": self.studentAddress.text!, "Headline": self.studentHeadline.text!, "Summary": self.studentSummary.text!])
                
            }
            
        })
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
