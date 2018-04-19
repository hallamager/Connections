//
//  StudentMoreInfoViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 08/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Koloda

class StudentMoreInfoViewController: UIViewController {
    
    var student: Student!
    var educations = [Education]()
    var experiences = [Experience]()
    var skills = [Skills]()
    let sections = ["Education", "Experience"]
    
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyIndustry: UILabel!
    @IBOutlet var companyDescription: UITextView!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var interestOne: UILabel!
    @IBOutlet weak var interestTwo: UILabel!
    @IBOutlet weak var interestThree: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyIndustry.text = student.address
        companyName.text = student.username
        companyDescription.text = student.headline
        interestOne.text = student.interestOne
        interestTwo.text = student.interestTwo
        interestThree.text = student.interestThree
        
        companyDescription.translatesAutoresizingMaskIntoConstraints = true
        companyDescription.sizeToFit()
        companyDescription.isScrollEnabled = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            self.companyImage.image = pic
        }
        
        let refSkills = Database.database().reference().child("student").child(student.uuid).child("skills")
        
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
        
        let refEducation = Database.database().reference().child("student").child(student.uuid).child("education")
        let refExperience = Database.database().reference().child("student").child(student.uuid).child("experience")
        
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
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

class SkillsMoreInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var skills: UILabel!
    
}

class ExperienceMoreInfoCell: UITableViewCell {
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var title: UILabel!
    
}

class EducationMoreInfoCell: UITableViewCell {
    
    @IBOutlet var company: UILabel!
    @IBOutlet var title: UILabel!
    
}

extension StudentMoreInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension StudentMoreInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillsCell", for: indexPath as IndexPath) as! SkillsMoreInfoCell
        
        let skill = skills[indexPath.row]
        
        cell.skills?.text = skill.skill
        
        return cell
    }
    
}

extension StudentMoreInfoViewController: UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! EducationMoreInfoCell
            let education = educations[indexPath.row]
            cell.company?.text = education.school
            cell.title?.text = education.studied
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "experienceCell") as! ExperienceMoreInfoCell
        let experience = experiences[indexPath.row]
        cell.company?.text = experience.company
        cell.title?.text = experience.title
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        print("cell \(self.experiences.count)")
        return cell
        
    }
    
}
