//
//  StudentEditProfileViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class StudentEditProfileViewController: UIViewController, UITextFieldDelegate {
    
    var students = [Student]()
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")

    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var userUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userUsername.delegate = self
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                self.userUsername.text = student.username
                self.students.append(student)
            }
        })
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        ref.updateChildValues(["Username": self.userUsername.text!])
        
    }
    
}
