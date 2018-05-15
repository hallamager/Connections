//
//  JobsPostedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 24/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ViewAnimator

class JobsPostedViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("Jobs")
    var jobs = [Job]()
    var students = [Student]()
    var business: Business!
    var job: Job!
    var student: Student!
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    var hasApplications: Bool {
        return students.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observe(.value, with: { snapshot in
            
            self.jobs.removeAll()
            
            for job in snapshot.children {
                if let data = job as? DataSnapshot {
                    if let job = Job(snapshot: data) {
                        self.jobs.append(job)
                    }
                }
            }
            
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            
            print("is\(self.jobs.count)")
            
        })
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    @IBAction func addJobs(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let AddJobsViewController:AddJobsViewController = storyboard.instantiateViewController(withIdentifier: "AddJobsViewController") as! AddJobsViewController
        self.navigationController?.pushViewController(AddJobsViewController, animated: true)
        
    }
    
}


extension JobsPostedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let job = jobs[indexPath.row]
        
        guard hasApplications else { return }
        
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let StudentAppliedViewController:StudentAppliedViewController = storyboard.instantiateViewController(withIdentifier: "StudentAppliedViewController") as! StudentAppliedViewController
        self.navigationController?.pushViewController(StudentAppliedViewController, animated: true)
        StudentAppliedViewController.job = job
        
    }
    
}

extension JobsPostedViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(jobs.count)
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsPostedCell") as! JobsPostedCell
        let job = jobs[indexPath.row]
        
        
        func loadRelatedStudents(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
            
            let ref = Database.database().reference(withPath: "jobsApplied/" + Auth.auth().currentUser!.uid).child(job.uuid!)
            ref.observeSingleEvent(of: .value) { snapshot in
                
                var uids = [String]()
                for child in snapshot.children {
                    let userData = child as! DataSnapshot
                    uids.append(userData.key)
                }
                
                let userRef = Database.database().reference(withPath: "student").child("valid")
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
        
        loadRelatedStudents(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            print("hi\(students.count)")
            cell.applicantCount?.text = String(students.count)
            
            if students.count == 1 {
                cell.applicantsVocab?.text = "Applicant"
            } else {
                cell.applicantsVocab?.text = "Applicants"
            }
            
        }
        
        cell.jobTitle?.text = job.title
        cell.employmentType?.text = job.employmentType
        
        return cell
    }
    
}
