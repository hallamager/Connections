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
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var dateSelected: UILabel!
    @IBOutlet weak var timeSelected: UILabel!
    @IBOutlet weak var time: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let currentDateValue = dateFormatter.string(from: date.date)
        dateSelected.text = "\(currentDateValue)"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currentTimeValue = timeFormatter.string(from: time.date)
        timeSelected.text = "\(currentTimeValue)"
        
        navigationItem.title = student.username
        
    }
    
    @IBAction func date(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let currentDateValue = dateFormatter.string(from: date.date)
        dateSelected.text = "\(currentDateValue)"
        
    }
    
    @IBAction func time(_ sender: Any) {

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currentTimeValue = timeFormatter.string(from: time.date)
        timeSelected.text = "\(currentTimeValue)"
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        let ref = Database.database().reference().child("organisedChats").child(student.uuid).child(Auth.auth().currentUser!.uid)
        
        ref.updateChildValues(["Date": self.dateSelected.text!, "Time": self.timeSelected.text!, "Invite Type": "Chat Invite", "Response": "Pending Response"])
        
    }
    
}
