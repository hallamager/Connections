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
    
    let editProfile = StudentEditProfileViewController()
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("education")
    
    @IBOutlet var school: UITextField!
    @IBOutlet var qType: UITextField!
    @IBOutlet var studied: UITextField!
    @IBOutlet var schoolFromDate: UITextField!
    @IBOutlet var schoolToDate: UITextField!
    @IBOutlet var grades: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
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
                
        guard let school = school.text, !school.isEmpty, let qType = qType.text, !qType.isEmpty, let studied = studied.text, !studied.isEmpty, let schoolFromDate = schoolFromDate.text, !schoolFromDate.isEmpty, let schoolToDate = schoolToDate.text, !schoolToDate.isEmpty, let grades = grades.text, !grades.isEmpty else {
            
            self.validationAlert.text! = "You must enter every text field to continue."
            
            return
            
        }
        
        let ex = Education(data: ["School": self.school.text!, "Qualification Type": self.qType.text!, "Studied": self.studied.text!, "From Date": self.schoolFromDate.text!, "To Date": self.schoolToDate.text!, "Grades": self.grades.text!])
        delegate?.didAddEducation(ex)
        self.navigationController?.popViewController(animated: true)
        ref.childByAutoId().setValue(ex.toDict())
        
    }
    
}
