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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // check if user has logged in thus not showing logging in page
//    override func viewDidAppear(_ animated: Bool) {
//        
//        if Auth.auth().currentUser != nil {
//            self.presentSwipeViewController()
//        }
//        
//    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
                        
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                AppManager.shared.appContainer.dismiss(animated: true, completion: nil)
                
//                if let firebaseError = error {
//                    print(firebaseError.localizedDescription)
//                    return
//                }
                                
            })
            
        }
        
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Login")
    }
    
}
