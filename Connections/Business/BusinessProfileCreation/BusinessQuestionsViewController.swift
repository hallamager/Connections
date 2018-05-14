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
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var questionOne: UITextField!
    @IBOutlet var questionTwo: UITextField!
    @IBOutlet var questionThree: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionOne.delegate = self
        questionTwo.delegate = self
        questionThree.delegate = self
        
        ref.observe(.value, with: { snapshot in
            if snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three"){
                
                if let business = Business(snapshot: snapshot) {
                    self.questionOne.text = business.questionOne
                    self.questionTwo.text = business.questionTwo
                    self.questionThree.text = business.questionThree
                    
                }
                
            }
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            
            self.validationAlert.textColor = UIColor.red
            
            return
            
        }
        
        ref.updateChildValues(["Question One": self.questionOne.text!, "Question Two": self.questionTwo.text!, "Question Three": self.questionThree.text!])
        
        self.presentBusinessProfileCreationViewController()

    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
