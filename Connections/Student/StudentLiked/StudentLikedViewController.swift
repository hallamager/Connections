//
//  StudentLikedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 11/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ViewAnimator

class StudentLikedViewController: UIViewController {
    
    let kCloseCellHeight: CGFloat = 160
    let kOpenCellHeight: CGFloat = 865
    let ref = Database.database().reference().child("student")
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    var students = [Student]()
    var skills = [Skills]()
    var educations = [Education]()
    var experiences = [Experience]()
    
    var student: Student!
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var openMenuLeft: UIBarButtonItem!
    @IBOutlet weak var noStudentsMatched: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadRelatedStudents(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            
            if students.count == 0 {
                self.noStudentsMatched.text! = "You haven't matched with any students yet. Get swiping!"
                print("true")
            } else {
                self.noStudentsMatched.text! = ""
            }
            
        }
        
        //open menu with tab bar button
        openMenuLeft.target = self.revealViewController()
        openMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    func loadRelatedStudents(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference(withPath: "matchesBusiness/" + Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "student")
            var students = [Student]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let student = Student(snapshot: snapshot)
                        students.append(student!)
                        count += 1
                        if count == uids.count {
                            completion(true, students)
                        }
                    }
                }
            } else {
                completion(true, students)
            }
            
        }
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? (tag: Int, student: Student) else { return }
        
        let vc = segue.destination as! OrganiseChatViewController
        vc.student = sender.student
        
    }
    
}

extension StudentLikedViewController: UITableViewDelegate {
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as StudentLikedCell = cell else {
            return
        }
        
        let student = students[indexPath.row]
        
        cell.studentName.text! = student.username
        cell.studentHeadline.text! = student.headline!
        cell.studentFoldedName.text! = student.username
        cell.studentFoldedHeadline.text! = student.headline!
        cell.studentSummary.text! = student.summary!
        cell.interestOne.text! = student.interestOne!
        cell.interestTwo.text! = student.interestTwo!
        cell.interestThree.text! = student.interestThree!
        
        cell.studentSummary.translatesAutoresizingMaskIntoConstraints = true
        cell.studentSummary.sizeToFit()
        cell.studentSummary.isScrollEnabled = false
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.studentImg.image = pic
            cell.studentFoldedImg.image = pic
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }

}

extension StudentLikedViewController: UITableViewDataSource {
 
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print("is\(students.count)")
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! StudentLikedCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let student = students[indexPath.row]
        
        let refSkills = Database.database().reference().child("student").child(student.uuid).child("skills")
        
        refSkills.observe(.value, with: { snapshot in
            self.skills.removeAll()
            for skill in snapshot.children {
                if let data = skill as? DataSnapshot {
                    if let skill = Skills(snapshot: data) {
                        
                        self.skills.append(skill)
                        
                        print("hello\(self.skills.count)")
                    }
                }
            }
            
            cell.collectionView.reloadData()
            
            print("is skill\(self.skills.count)")
            
        })
        
        let refEducation = Database.database().reference().child("student").child(student.uuid).child("education")
        
        refEducation.observe(.value, with: { snapshot in
            
            self.educations.removeAll()
            
            for education in snapshot.children {
                if let data = education as? DataSnapshot {
                    if let education = Education(snapshot: data) {
                        self.educations.append(education)
                    }
                }
            }
            
            cell.educationCollectionView.reloadData()
            
            print("education \(self.educations.count)")
            
        })
        
        let refExperience = Database.database().reference().child("student").child(student.uuid).child("experience")
        
        refExperience.observe(.value, with: { snapshot in
            
            self.experiences.removeAll()
            
            for experience in snapshot.children {
                if let data = experience as? DataSnapshot {
                    if let experience = Experience(snapshot: data) {
                        self.experiences.append(experience)
                    }
                }
            }
            
            cell.experienceCollectionView.reloadData()
            
            print("experience \(self.experiences.count)")
            
        })
        
        cell.student = student
        cell.delegate = self
        
        print(student.username)
        
        return cell
    }
    
}

extension StudentLikedViewController: StudentSelectChatCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if getCurrentCellIndexPath(sender) != nil {
            
            if sender.tag == 1 {
                
                let revealViewController:SWRevealViewController = self.revealViewController()
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
                let desController = mainStoryboard.instantiateViewController(withIdentifier: "SelectStudentViewController") as! SelectStudentViewController
                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                
                revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                
            }
            
        }
        
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    func selected(for student: Student) {
        print(student)
        
        performSegue(withIdentifier: "organiseChat", sender: (tag: 2, student: student))
    }
    
}
