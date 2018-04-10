//
//  AppManager.swift
//  Connections
//
//  Created by Hallam John Ager on 07/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class AppManager {
    
    static let shared = AppManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: LogInViewController!
    
    private init() { }
    
    func logout() {
        
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}
