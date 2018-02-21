//
//  EditExperienceViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 21/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditExperienceViewController: UIViewController, UITextFieldDelegate {
    
    var experience: Experience!
    var experiences = [Experience]()
    
    @IBOutlet var jobTitle: UITextField!
    @IBOutlet var jobCompany: UITextField!
    @IBOutlet var jobCity: UITextField!
    @IBOutlet var jobFromDate: UITextField!
    @IBOutlet var jobToDate: UITextField!
    @IBOutlet var jobDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTitle.delegate = self
        jobCompany.delegate = self
        jobCity.delegate = self
        jobFromDate.delegate = self
        jobToDate.delegate = self
        jobDescription.delegate = self
        
        jobTitle.text = experience.title
        jobCompany.text = experience.company
        jobCity.text = experience.location
        jobFromDate.text = experience.fromDate
        jobToDate.text = experience.toDate
        jobDescription.text = experience.description
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
    }
    
}
