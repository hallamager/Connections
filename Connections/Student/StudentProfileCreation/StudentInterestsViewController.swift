//
//  StudentInterestsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 25/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StudentInterestsViewController: UIViewController, UITextFieldDelegate {
    
    var students = [Student]()
    let ref = Database.database().reference().child("student").child("pending").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var interestOne: UITextField!
    @IBOutlet var interestTwo: UITextField!
    @IBOutlet var interestThree: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestOne.delegate = self
        interestTwo.delegate = self
        interestThree.delegate = self
        
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Interest One") && snapshot.hasChild("Interest Two") && snapshot.hasChild("Interest Three"){
                
                if let student = Student(snapshot: snapshot) {
                    self.interestOne.text = student.interestOne
                    self.interestTwo.text = student.interestTwo
                    self.interestThree.text = student.interestThree
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
        
        guard let interestOne = interestOne.text, !interestOne.isEmpty, let interestTwo = interestTwo.text, !interestTwo.isEmpty, let interestThree = interestThree.text, !interestThree.isEmpty else {
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x - 10, y: self.validationAlert.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x + 10, y: self.validationAlert.center.y))
            
            self.validationAlert.layer.add(animation, forKey: "position")
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            self.validationAlert.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
            
            return
            
        }
   
        ref.updateChildValues(["Interest One": self.interestOne.text!, "Interest Two": self.interestTwo.text!, "Interest Three": self.interestThree.text!])
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
   
}


