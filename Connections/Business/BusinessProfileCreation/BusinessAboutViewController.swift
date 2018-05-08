//
//  BusinessAboutViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 04/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessAboutViewController: UIViewController, UITextFieldDelegate {
    
    var business: Business!
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)

    @IBOutlet var companyIndustry: UITextField!
    @IBOutlet var companyDescription: UITextView!
    @IBOutlet weak var headquarters: UITextField!
    @IBOutlet weak var companySize: UITextField!
    @IBOutlet weak var companyWebsite: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        companyIndustry.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmAbout(_ sender: UIButton) {
        
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
        
        guard let companyIndustry = companyIndustry.text, !companyIndustry.isEmpty, let companyDescription = companyDescription.text, !companyDescription.isEmpty, let headquarters = headquarters.text, !headquarters.isEmpty, let companySize = companySize.text, !companySize.isEmpty, let companyWebsite = companyWebsite.text, !companyWebsite.isEmpty else {
            
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
        
        ref.updateChildValues(["Industry": self.companyIndustry.text!, "Description": self.companyDescription.text!, "Headquarters": self.headquarters.text!, "Company Size": self.companySize.text!, "Website": self.companyWebsite.text!,])
        
        self.presentBusinessProfileCreationViewController()
        
    }
    
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
