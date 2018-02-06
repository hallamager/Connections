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
    
    // check if user has logged in thus not showing logging in page
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            self.presentSwipeViewController()
        }
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
//                if let firebaseError = error {
//                    print(firebaseError.localizedDescription)
//                    return
//                }
                
                if error == nil {
                    // Get the type from the database. It's path is users/<userId>/type.
                    // Notice "observeSingleEvent", so we don't register for getting an update every time it changes.
                    Database.database().reference().child("users/\(user!.uid)/type").observeSingleEvent(of: .value, with: {
                        (snapshot) in
                        
                        switch snapshot.value as! String {
                        // If our user is admin...
                        case "business":
                            // ...redirect to the student page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StudentSwipeViewController")
                            self.present(vc!, animated: true, completion: nil)
                        // If out user is a regular user...
                        case "student":
                            // ...redirect to the business page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                            self.present(vc!, animated: true, completion: nil)
                        // If the type wasn't found...
                        default:
                            // ...print an error
                            print("Error: Couldn't find type for user \(user!.uid)")
                        }
                    })
                }
                
                self.presentSwipeViewController()
                
            })
            
        }
        
    }
    
    func presentSwipeViewController() {
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        self.present(SWRevealViewController, animated: true, completion: nil)
        
//        func loggedIn() {
//            if() {
//                performSegue(withIdentifier: "showbusiness", sender: self)
//            } else {
//                performSegue(withIdentifier: "showstudents", sender: self)
//            }
//        }
        
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Login")
    }
    
}
