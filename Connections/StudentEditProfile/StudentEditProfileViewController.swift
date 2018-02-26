//
//  StudentEditProfileViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class StudentEditProfileViewController: UIViewController {
    
    var students = [Student]()
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")

    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var userUsername: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var distanceSelected: UILabel!
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                self.userUsername.text = student.username
                self.students.append(student)
            }
        })
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child((Auth.auth().currentUser?.uid)!)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            self.profilePic.image = pic
        }
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        ref.updateChildValues(["Username": self.userUsername.text!])
        
    }
    
    @IBAction func sliderDistance(_ sender: UISlider) {
        
        let currentValue = Int(slider.value)
        distanceSelected.text = "\(currentValue)Km"
        
    }
    
}
