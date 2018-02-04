//
//  StudentCreateProfileLandingViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

class StudentCreateProfileLandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func presentBusinessSwipeViewViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
    }
    
}
