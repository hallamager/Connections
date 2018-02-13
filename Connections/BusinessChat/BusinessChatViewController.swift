//
//  BusinessChatViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 11/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessChatViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chatTextField: UITextField!
    
    var messagesController: BusinessLikedViewController?
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = business?.username
        
    }
    
    @IBAction func chatMessageSendButton(_ sender: Any) {
        handleSend()
    }
    
    
    func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let values = ["text": chatTextField.text!]
        childRef.updateChildValues(values)
        
    }
    
}
