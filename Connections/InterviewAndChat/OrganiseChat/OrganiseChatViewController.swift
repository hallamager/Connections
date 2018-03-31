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
    @IBOutlet weak var dateSelected2: UIDatePicker!
    @IBOutlet weak var timeSelected2: UIDatePicker!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var date2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let currentDateValue = dateFormatter.string(from: date.date)
        dateSelected.text = "\(currentDateValue)"
        let currentDateValue2 = dateFormatter.string(from: dateSelected2.date)
        date2.text = "\(currentDateValue2)"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currentTimeValue = timeFormatter.string(from: time.date)
        timeSelected.text = "\(currentTimeValue)"
        let currentTimeValue2 = timeFormatter.string(from: timeSelected2.date)
        time2.text = "\(currentTimeValue2)"
        
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
    
    @IBAction func date2(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let currentDateValue2 = dateFormatter.string(from: dateSelected2.date)
        date2.text = "\(currentDateValue2)"
        
    }
    
    @IBAction func time2(_ sender: Any) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currentTimeValue2 = timeFormatter.string(from: timeSelected2.date)
        time2.text = "\(currentTimeValue2)"
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        let ref = Database.database().reference().child("organisedChats").child(student.uuid).child(Auth.auth().currentUser!.uid)
        
        let refBusiness = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(student.uuid)
        
        ref.updateChildValues(["Date1": self.dateSelected.text!, "Time1": self.timeSelected.text!, "Date2": self.date2.text!, "Time2": self.time2.text!, "Invite Type": "Chat Invite", "Response": "Pending Response", "First Date Response": "Pending Response", "Second Date Response": "Pending Response"])
        
        refBusiness.updateChildValues(["Date1": self.dateSelected.text!, "Time1": self.timeSelected.text!, "Date2": self.date2.text!, "Time2": self.time2.text!, "Invite Type": "Chat Invite", "Response": "Pending Response", "First Date Response": "Pending Response", "Second Date Response": "Pending Response"])
        
        let revealViewController:SWRevealViewController = self.revealViewController()
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "StudentInviteViewController") as! StudentInviteViewController
        let newFrontViewController = UINavigationController.init(rootViewController:desController)
        
        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        
    }
    
}
