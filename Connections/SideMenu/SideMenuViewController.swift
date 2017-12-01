//
//  SideMenuViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SideMenuViewController: UIViewController {
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("There was a problem loggin out")
        }
    }
    
}
