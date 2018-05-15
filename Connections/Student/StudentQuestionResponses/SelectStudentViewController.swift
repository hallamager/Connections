//
//  SelectStudentViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FoldingCell
import ViewAnimator
import Spring

class SelectStudentViewController: UIViewController {
    
    var businesses = [Business]()
    var students = [Student]()
    var student: Student!
    var studentResponses = [StudentResponses]()
    let kCloseCellHeight: CGFloat = 130
    let kOpenCellHeight: CGFloat = 340
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noStudentAnswers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadStudentsWhoResponsed(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            
            if students.count == 0 {
                self.noStudentAnswers.text! = "No students have answered your questions yet. We'll alert you when they do!"
                print("true")
            } else {
                self.noStudentAnswers.text! = ""
            }
            
        }
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    func loadStudentsWhoResponsed(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference().child("studentResponses/\(Auth.auth().currentUser!.uid)")

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
        
        let vc = segue.destination as! ViewStudentResponses
        vc.student = sender.student
        vc.questionNumber = sender.tag
        
    }
    
}

extension SelectStudentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as ResponsesCell = cell else {
            return
        }
        
        let student = students[indexPath.row]
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.studentName?.text = student.username
        cell.studentHeadline?.text = student.headline
        cell.foldedStudentName?.text = student.username
        cell.foldedStudentHeadline?.text = student.headline
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.studentImg.image = pic
            cell.foldedStudentImg.image = pic
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

extension SelectStudentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print(students.count)
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell") as! ResponsesCell
        
        let student = students[indexPath.row]
        cell.student = student
        cell.delegate = self
        print(student.username)
        
        let refHasAnswered = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid)
        
        refHasAnswered.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Answer One") {
                cell.answerOne.isEnabled = true
                
                cell.answerOneImg.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.20),
                               initialSpringVelocity: CGFloat(1.0),
                               options: [.repeat, .autoreverse],
                               animations: {
                                cell.answerOneImg.transform = CGAffineTransform.identity
                },
                               completion: { Void in()  }
                )
                
            } else {
                cell.answerOne.isEnabled = false
                cell.answerOneImg.isHidden = true
            }
            
        })
        
        refHasAnswered.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Answer Two") {
                cell.answerTwo.isEnabled = true
                
                cell.answerTwoImg.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.20),
                               initialSpringVelocity: CGFloat(1.0),
                               options: [.repeat, .autoreverse],
                               animations: {
                                cell.answerTwoImg.transform = CGAffineTransform.identity
                },
                               completion: { Void in()  }
                )
                
            } else {
                cell.answerTwo.isEnabled = false
                cell.answerTwoImg.isHidden = true
            }
            
        })
        
        refHasAnswered.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Answer Three") {
                cell.answerThree.isEnabled = true
                
                cell.answerThreeImg.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.20),
                               initialSpringVelocity: CGFloat(1.0),
                               options: [.repeat, .autoreverse],
                               animations: {
                                cell.answerThreeImg.transform = CGAffineTransform.identity
                },
                               completion: { Void in()  }
                )
                
            } else {
                cell.answerThree.isEnabled = false
                cell.answerThreeImg.isHidden = true
            }
            
        })
        
        return cell
        
    }
    
}

extension SelectStudentViewController: StudentSelectCellDelegate {
    
    func selected(question: Int, for student: Student) {
        print(question)
        print(student)
        
        performSegue(withIdentifier: "QuestionSelected", sender: (tag: question, student: student))
    }
    
}
