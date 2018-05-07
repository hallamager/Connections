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
    var pickerVC = PickerViewController()
    
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var time2: UILabel! 
    @IBOutlet weak var interviewLocation: UITextField!
    @IBOutlet weak var moreInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = student.username
        
    }
    
    @IBAction func firstDateBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "StudentMain", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        modal.showTimePicker = false
        modal.onConfirm = firstDate
        self.present(modal, animated: true)
    }
    
    @IBAction func firstTimeBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "StudentMain", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        modal.showTimePicker = true
        modal.onConfirm = firstTime
        self.present(modal, animated: true)
    }
    
    @IBAction func secondDateBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "StudentMain", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        modal.showTimePicker = false
        modal.onConfirm = secondDate
        self.present(modal, animated: true)
    }
    
    @IBAction func secondTimeBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "StudentMain", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        modal.showTimePicker = true
        modal.onConfirm = secondTime
        self.present(modal, animated: true)
    }
    
    func firstDate(_ data: String) -> () {
        date1.text = data
    }
    
    func secondDate(_ data: String) -> () {
        date2.text = data
    }
    
    func firstTime(_ data: String) -> () {
        time1.text = data
    }
    
    func secondTime(_ data: String) -> () {
        time2.text = data
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        let ref = Database.database().reference().child("organisedChats").child(student.uuid).child(Auth.auth().currentUser!.uid)

        let refBusiness = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(student.uuid)

        ref.updateChildValues(["Date1": self.date1.text!, "Time1": self.time1.text!, "Date2": self.date2.text!, "Time2": self.time2.text!, "Location": self.interviewLocation.text!, "MoreInfo": self.moreInfo.text!, "Invite Type": "Interview Invite", "Response": "Pending Response", "First Date Response": "Pending Response", "Second Date Response": "Pending Response"])

        refBusiness.updateChildValues(["Date1": self.date1.text!, "Time1": self.time1.text!, "Date2": self.date2.text!, "Time2": self.time2.text!, "Location": self.interviewLocation.text!, "MoreInfo": self.moreInfo.text!, "Invite Type": "Interview Invite", "Response": "Pending Response", "First Date Response": "Pending Response", "Second Date Response": "Pending Response"])

        let revealViewController:SWRevealViewController = self.revealViewController()

        let mainStoryboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "StudentInviteViewController") as! StudentInviteViewController
        let newFrontViewController = UINavigationController.init(rootViewController:desController)

        revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        
    }
    
}
