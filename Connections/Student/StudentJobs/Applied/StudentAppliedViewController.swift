//
//  StudentAppliedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 24/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ViewAnimator

class StudentAppliedViewController: UIViewController {
    
    var job: Job!
    var students = [Student]()
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRelatedStudents(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
        }
        
    }
    
    func loadRelatedStudents(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference(withPath: "jobsApplied/" + Auth.auth().currentUser!.uid).child(job.uuid!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? (tag: Int, student: Student) else { return }
        
        let vc = segue.destination as! OrganiseChatViewController
        vc.student = sender.student
        
    }
    
}

extension StudentAppliedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension StudentAppliedViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(students.count)
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentAppliedCell") as! StudentAppliedCell
        
        let student = students[indexPath.row]
        
        cell.student = student
        cell.delegate = self
        
        cell.studentName?.text = student.username
        cell.studentHeadline?.text = student.headline
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.companyImg.image = pic
        }
        
        return cell
    }
    
}

extension StudentAppliedViewController: StudentInviteChatCellDelegate {
    
    func selected(for student: Student) {
        print(student)
        
        performSegue(withIdentifier: "organiseInterview", sender: (tag: 2, student: student))
    }
    
}

