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
    
    let sections = ["Education", "Experience"]
    
    var students = [Student]()
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")
    let refEducation = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education")
    let refExperience = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience")
    let refSkills = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("skills")
    var educations = [Education]()
    var experiences = [Experience]()
    var skills = [Skills]()

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
        
        refEducation.observe(.value, with: { snapshot in
            
            self.educations.removeAll()
            
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
        
        refExperience.observe(.value, with: { snapshot in
            
            self.experiences.removeAll()

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
        ref.updateChildValues(["Selected Radius": self.distanceSelected.text!])
        
    }
    
    @IBAction func addEducation(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
        let AddEducationViewController:AddEducationViewController = storyboard.instantiateViewController(withIdentifier: "AddEducationViewController") as! AddEducationViewController
        self.present(AddEducationViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func addExperience(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
        let AddExperienceViewController:AddExperienceViewController = storyboard.instantiateViewController(withIdentifier: "AddExperienceViewController") as! AddExperienceViewController
        self.present(AddExperienceViewController, animated: true, completion: nil)
        
    }
    
}

extension StudentEditProfileViewController: EditExperienceControllerDelegate {
    
    func didEditExperience(_ experience: Experience) {
        self.experiences.append(experience)
        self.tableView.reloadData()
    }
    
}

extension StudentEditProfileViewController: EditEducationControllerDelegate {
    
    func didEditEducation(_ education: Education) {
        self.educations.append(education)
        self.tableView.reloadData()
    }
    
}

extension StudentEditProfileViewController: AddExperienceControllerDelegate {
    
    func didAddExperience(_ experience: Experience) {
        self.experiences.append(experience)
        self.tableView.reloadData()
    }
    
}

extension StudentEditProfileViewController: AddEducationControllerDelegate {
    
    func didAddEducation(_ education: Education) {
        self.educations.append(education)
        self.tableView.reloadData()
    }
    
}

extension StudentEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
            let EditEducationViewController:EditEducationViewController = storyboard.instantiateViewController(withIdentifier: "EditEducationViewController") as! EditEducationViewController
            EditEducationViewController.education = educations[indexPath.row]
            self.present(EditEducationViewController, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 {
            let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
            let EditExperienceViewController:EditExperienceViewController = storyboard.instantiateViewController(withIdentifier: "EditExperienceViewController") as! EditExperienceViewController
            EditExperienceViewController.experience = experiences[indexPath.row]
            self.present(EditExperienceViewController, animated: true, completion: nil)
        }
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let image = (Bundle.main.loadNibNamed("EducationTitle", owner: self, options: nil)![0] as? UIView)
            return image
        }
        
        let image = (Bundle.main.loadNibNamed("ExperienceTitle", owner: self, options: nil)![0] as? UIView)
        return image
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
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

