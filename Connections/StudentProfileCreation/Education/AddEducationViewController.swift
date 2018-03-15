//
//  AddEducationViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddEducationControllerDelegate: class {
    func didAddEducation(_ education: Education)
}

class AddEducationViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("education")
    
    @IBOutlet var school: UITextField!
    @IBOutlet var qType: UITextField!
    @IBOutlet var studied: UITextField!
    @IBOutlet var schoolFromDate: UITextField!
    @IBOutlet var schoolToDate: UITextField!
    @IBOutlet var grades: UITextField!
    
    weak var delegate: AddEducationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        school.delegate = self
        qType.delegate = self
        studied.delegate = self
        schoolFromDate.delegate = self
        schoolToDate.delegate = self
        grades.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        let ex = Education(data: ["School": self.school.text!, "Qualification Type": self.qType.text!, "Studied": self.studied.text!, "From Date": self.schoolFromDate.text!, "To Date": self.schoolToDate.text!, "Grades": self.grades.text!])
        //        delegate?.didAddExperience(ex)
        //        dismiss(animated: true, completion: nil)
        ref.childByAutoId().setValue(ex.toDict())
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
        let ShowEducationAddedViewController:ShowEducationAddedViewController = storyboard.instantiateViewController(withIdentifier: "ShowEducationAddedViewController") as! ShowEducationAddedViewController
        self.present(ShowEducationAddedViewController, animated: true, completion: nil)
        
    }
    
}
