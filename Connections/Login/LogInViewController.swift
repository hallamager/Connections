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

class LogInViewController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorValidation: UILabel!
    @IBOutlet weak var loginBtn: UIButtonStyles!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
