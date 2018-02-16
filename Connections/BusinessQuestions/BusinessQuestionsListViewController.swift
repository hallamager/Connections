//
//  BusinessQuestionsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessQuestionsListViewController: UIViewController {
    
    var business: Business!
    
    @IBOutlet var questionOne: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionOne.text = business.questionOne
        
    }
    
}
