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
    let refExperience = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience")
    var educations = [Education]()
    var experiences = [Experience]()
    weak var delegate: StudentEditProfileViewControllerDelegate?

    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var userUsername: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var distanceSelected: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var interestOne: UILabel!
    @IBOutlet weak var interestTwo: UILabel!
    @IBOutlet weak var interestThree: UILabel!
    @IBOutlet weak var experienceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                self.userUsername.text = student.username
                self.slider.value = Float(Int(student.selectedRadius))
                self.distanceSelected.text = "\(student.selectedRadius)"
                self.summary.text = student.summary
                self.interestOne.text = student.interestOne
                self.interestTwo.text = student.interestTwo
                self.interestThree.text = student.interestThree
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
            
            print("education \(self.educations.count)")
            
        })
        
        refExperience.observeSingleEvent(of: .value, with: { snapshot in
            for experience in snapshot.children {
                if let data = experience as? DataSnapshot {
                    if let experience = Experience(snapshot: data) {
                        self.experiences.append(experience)
                    }
                }
            }
            
            self.experienceTableView.reloadData()
            
            print("experience \(self.experiences.count)")
            
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
        return 130
    }
    
}

extension StudentEditProfileViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        if tableView == self.experienceTableView {
            print("row \(self.experiences.count)")
            return experiences.count
        } else {
            print("row \(self.educations.count)")
            return educations.count
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! EducationCell
            let education = educations[indexPath.row]
            cell.school?.text = education.school
            cell.studied?.text = education.studied
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "experienceCell") as! ExperienceCell
            let experience = experiences[indexPath.row]
            cell.company?.text = experience.company
            cell.title?.text = experience.title
            print("cell \(self.experiences.count)")
            return cell
            
        }
        
    }
    
}

