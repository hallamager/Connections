//
//  LogInViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 13/10/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import Firebase 
import IQKeyboardManagerSwift
import GeoFire

class LogInViewController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorValidation: UILabel!
    @IBOutlet weak var loginBtn: UIButtonStyles!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.locationManager.requestAlwaysAuthorization()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [LogInViewController.self]
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(LogInViewController.self)
                        
    }
    
    
    
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func password(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -90, up: true)
    }
    
    @IBAction func passwordLeave(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -90, up: false)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        
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
        
        let email = self.emailTextField.text
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            if let firebaseError = error {
                
                self.errorValidation.text = "You haven't enetered an email address."
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
                
                self.errorValidation.layer.add(animation, forKey: "position")
                
                print(firebaseError.localizedDescription)
                
            } else {
                
                self.errorValidation.text = "A reset password link has been sent to your email."
                self.errorValidation.textColor = UIColor(red: 13/255, green: 97/255, blue: 40/255, alpha: 1.0)
                
                print("Reset password email sent")

            }
        }
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {

            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in

                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.errorValidation.text = "Username or password are invalid"
                    self.emailTextField.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                    self.passwordTextField.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                    
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
                    
                    self.errorValidation.layer.add(animation, forKey: "position")
                    
                    return
                }

                self.emailTextField.textColor = UIColor.black
                self.passwordTextField.textColor = UIColor.black
                self.errorValidation.text = ""
                AppManager.shared.appContainer.dismiss(animated: true, completion: nil)

            })
            
            
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

        }
        
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Login")
    }
    
}
