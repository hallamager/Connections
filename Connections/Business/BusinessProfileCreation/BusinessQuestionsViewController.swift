//
//  BusinessQuestionsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 15/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessQuestionsViewController: UIViewController, UITextFieldDelegate {
    
    var businesses = [Business]()
    let refPending = Database.database().reference().child("business").child("pending").child(Auth.auth().currentUser!.uid)
    let refValid = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid)
    let refCheckValid = Database.database().reference().child("business").child("valid")
    
    @IBOutlet var questionOne: UITextField!
    @IBOutlet var questionTwo: UITextField!
    @IBOutlet var questionThree: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionOne.delegate = self
        questionTwo.delegate = self
        questionThree.delegate = self
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                print("hello valid")
                
                self.refValid.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three"){
                        
                        if let business = Business(snapshot: snapshot) {
                            self.questionOne.text = business.questionOne
                            self.questionTwo.text = business.questionTwo
                            self.questionThree.text = business.questionThree
                        }
                        
                    }
                }
                
            } else {
                
                print("hello pending")
                
                self.refPending.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three"){
                        
                        if let business = Business(snapshot: snapshot) {
                            self.questionOne.text = business.questionOne
                            self.questionTwo.text = business.questionTwo
                            self.questionThree.text = business.questionThree
                        }
                        
                    }
                }
                
            }
            
        })
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    @IBAction func confirmButtom(_ sender: UIButton) {
        
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
        
        guard let questionOne = questionOne.text, !questionOne.isEmpty, let questionTwo = questionTwo.text, !questionTwo.isEmpty, let questionThree = questionThree.text, !questionThree.isEmpty else {
            
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
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                self.refValid.updateChildValues(["Question One": self.questionOne.text!, "Question Two": self.questionTwo.text!, "Question Three": self.questionThree.text!])
                
            } else {
                
                self.refPending.updateChildValues(["Question One": self.questionOne.text!, "Question Two": self.questionTwo.text!, "Question Three": self.questionThree.text!])
                
            }
            
        })
        
        self.presentBusinessProfileCreationViewController()

    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
