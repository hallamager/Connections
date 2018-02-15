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
    var messages = [Messages]()
    
    @IBOutlet var openMenuLeft: UIBarButtonItem!
    @IBAction func newMessage(_ sender: Any) {
        handleNewMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //open menu with tab bar button
        openMenuLeft.target = self.revealViewController()
        openMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableView.reloadData()
        
        observeMessages()
        
    }
    
    func observeMessages () {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let message = Messages(snapshot: snapshot) {
                self.messages.append(message)
                print(message.text)
            }


        }, withCancel: nil)
    }
    
    
    func handleNewMessage() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let businessSelectNewChatViewController:BusinessSelectNewChatViewController = storyboard.instantiateViewController(withIdentifier: "BusinessSelectNewChatViewController") as! BusinessSelectNewChatViewController
//        self.present(businessSelectNewChatViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(businessSelectNewChatViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessChatList")!
        
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.text
        
        print(message.text)
        
        return cell
    }

    
}

