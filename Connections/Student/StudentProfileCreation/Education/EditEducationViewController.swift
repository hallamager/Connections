//
//  EditEducationViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol EditEducationControllerDelegate: class {
    func didEditEducation(_ education: Education)
}

class EditEducationViewController: UIViewController, UITextFieldDelegate {
    
    var education: Education!
    var educations = [Education]()
    
    @IBOutlet var school: UITextField!
    @IBOutlet var qType: UITextField!
    @IBOutlet var studied: UITextField!
    @IBOutlet var schoolFromDate: UITextField!
    @IBOutlet var schoolToDate: UITextField!
    @IBOutlet var grades: UITextField!
    @IBOutlet weak var validationAlert: UILabel!
    
    weak var delegate: EditEducationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        school.delegate = self
        qType.delegate = self
        studied.delegate = self
        schoolFromDate.delegate = self
        schoolToDate.delegate = self
        grades.delegate = self
        
        school.text = education.school
        qType.text = education.qType
        studied.text = education.studied
        schoolFromDate.text = education.fromDate
        schoolToDate.text = education.toDate
        grades.text = education.grades
        
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
        
        let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education").child(education.uuid!)
        
        let ex = Education(data: ["School": self.school.text!, "Qualification Type": self.qType.text!, "Studied": self.studied.text!, "From Date": self.schoolFromDate.text!, "To Date": self.schoolToDate.text!, "Grades": self.grades.text!])
        
        ref.updateChildValues(ex.toDict())
        
        delegate?.didEditEducation(ex)
        self.navigationController?.popViewController(animated: true)

    }
    
}
