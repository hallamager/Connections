//
//  StudentMoreInfoViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 08/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Koloda

class StudentMoreInfoViewController: UIViewController {
    
    var student: Student!
    
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyIndustry: UILabel!
    @IBOutlet var companyDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyIndustry.text = student.address
        companyName.text = student.username
        companyDescription.text = student.headline
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
