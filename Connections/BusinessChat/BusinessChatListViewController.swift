//
//  BusinessChatListViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 11/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessChatListViewController: UITableViewController {
    
    var businesses = [Business]()
    
    @IBOutlet var openMenuLeft: UIBarButtonItem!
    @IBAction func newMessage(_ sender: Any) {
        handleNewMessage()
    }
    @IBAction func showChatController(_ sender: Any) {
//        showChatControllerForUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //open menu with tab bar button
        openMenuLeft.target = self.revealViewController()
        openMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func handleNewMessage() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let businessSelectNewChatViewController:BusinessSelectNewChatViewController = storyboard.instantiateViewController(withIdentifier: "BusinessSelectNewChatViewController") as! BusinessSelectNewChatViewController
//        self.present(businessSelectNewChatViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(businessSelectNewChatViewController, animated: true)
    }

    
}

