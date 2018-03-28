//
//  OrganiseChatViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 27/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class OrganiseChatViewController: UIViewController {
    
    var student: Student!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = student.username
        
    }
    
}
