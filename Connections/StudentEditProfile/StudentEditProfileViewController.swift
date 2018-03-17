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
    
    let sections = ["Education", "Experience"]
    
    var students = [Student]()
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")
    let refEducation = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education")
    let refExperience = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience")
    let refSkills = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("skills")
    var educations = [Education]()
    var experiences = [Experience]()
    var skills = [Skills]()
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
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        refSkills.observe(.value, with: { snapshot in
            self.skills.removeAll()
            for skill in snapshot.children {
                if let data = skill as? DataSnapshot {
                    if let skill = Skills(snapshot: data) {
                        
                        self.skills.append(skill)
                    }
                }
            }
            
            self.collectionView.reloadData()
            
            print("is\(self.skills.count)")
            
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
            
            self.tableView.reloadData()
            
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return educations.count
        }
        
        return experiences.count

    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let image = UIImageView(image: UIImage(named: "studentImg"))
//        return image
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! EducationCell
            let education = educations[indexPath.row]
            cell.school?.text = education.school
            cell.studied?.text = education.studied
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "experienceCell") as! ExperienceCell
        let experience = experiences[indexPath.row]
        cell.company?.text = experience.company
        cell.title?.text = experience.title
        print("cell \(self.experiences.count)")
        return cell

    }
    
}

