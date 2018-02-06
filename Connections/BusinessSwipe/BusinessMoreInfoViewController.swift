//
//  BusinessMoreInfoViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Koloda

class BusinessMoreInfoViewController: UIViewController {
    
    var business: Business!
        
    @IBOutlet var companyIndustry: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyIndustry.text = business.industry
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

