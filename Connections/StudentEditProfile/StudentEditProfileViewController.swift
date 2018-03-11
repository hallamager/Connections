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

protocol StudentEditProfileViewControllerDelegate: class {
    
    func sliderChanged(text:String?)
    
}

class StudentEditProfileViewController: UIViewController {
    
    var students = [Student]()
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")
    let refEducation = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education")
    var educations = [Education]()
    weak var delegate: StudentEditProfileViewControllerDelegate?

    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var userUsername: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var distanceSelected: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                self.userUsername.text = student.username
                self.slider.value = Float(Int(student.selectedRadius))
                self.distanceSelected.text = "\(student.selectedRadius)"
                self.summary.text = student.summary
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
        
        refEducation.observeSingleEvent(of: .value, with: { snapshot in
            for education in snapshot.children {
                if let data = education as? DataSnapshot {
                    if let education = Education(snapshot: data) {
                        self.educations.append(education)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            print("is\(self.educations.count)")
            
        })
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    
    @IBAction func sliderDistance(_ sender: UISlider) {
        
        let currentValue = Int(slider.value)
        distanceSelected.text = "\(currentValue)"
        delegate?.sliderChanged(text: distanceSelected.text)
        ref.updateChildValues(["Selected Radius": self.distanceSelected.text!])
        
    }
    
}

extension StudentEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EditEducationViewController:EditEducationViewController = storyboard.instantiateViewController(withIdentifier: "EditEducationViewController") as! EditEducationViewController
        EditEducationViewController.education = educations[indexPath.row]
        self.present(EditEducationViewController, animated: true, completion: nil)
        
    }
    
}

extension StudentEditProfileViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(educations.count)
        return educations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! EducationCell
        let education = educations[indexPath.row]
        cell.school?.text = education.school
        cell.studied?.text = education.studied
        return cell
    }
    
}

