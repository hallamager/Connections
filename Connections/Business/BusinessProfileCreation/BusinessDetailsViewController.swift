//
//  BusinessDetailsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessDetailsViewController: UIViewController, UITextFieldDelegate {
    
    let refPending = Database.database().reference().child("business").child("pending").child(Auth.auth().currentUser!.uid)
    let refValid = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid)
    let refCheckValid = Database.database().reference().child("business").child("valid")
    
    @IBOutlet var cultureOne: UITextField!
    @IBOutlet var cultureTwo: UITextField!
    @IBOutlet var cultureThree: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cultureOne.delegate = self
        cultureTwo.delegate = self
        cultureThree.delegate = self
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                print("hello valid")
                
                self.refValid.observe(.value, with: { snapshot in
                    if snapshot.hasChild("cultureOne") && snapshot.hasChild("cultureTwo") && snapshot.hasChild("cultureThree"){
                        
                        if let business = Business(snapshot: snapshot) {
                            self.cultureOne.text = business.cultureOne
                            self.cultureTwo.text = business.cultureTwo
                            self.cultureThree.text = business.cultureThree
                        }
                        
                    }
                })
                
            } else {
                
                print("hello pending")
                
                self.refPending.observe(.value, with: { snapshot in
                    if snapshot.hasChild("cultureOne") && snapshot.hasChild("cultureTwo") && snapshot.hasChild("cultureThree"){
                        
                        if let business = Business(snapshot: snapshot) {
                            self.cultureOne.text = business.cultureOne
                            self.cultureTwo.text = business.cultureTwo
                            self.cultureThree.text = business.cultureThree
                        }
                        
                    }
                })
                
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
        
        guard let cultureOne = cultureOne.text, !cultureOne.isEmpty, let cultureTwo = cultureTwo.text, !cultureTwo.isEmpty, let cultureThree = cultureThree.text, !cultureThree.isEmpty else {
            
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
                
                print("hello valid")
                
                self.refValid.updateChildValues(["cultureOne": self.cultureOne.text!, "cultureTwo": self.cultureTwo.text!, "cultureThree": self.cultureThree.text!])
                
            } else {
                
                print("hello pending")
                
                self.refPending.updateChildValues(["cultureOne": self.cultureOne.text!, "cultureTwo": self.cultureTwo.text!, "cultureThree": self.cultureThree.text!])
                
            }
            
        })
        
        self.presentBusinessProfileCreationViewController()
        
    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
