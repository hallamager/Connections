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
    
    let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs")
    var jobs = [Job]()
    var students = [Student]()
    var business: Business!
    var job: Job!
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
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
        
    }
    
}


extension JobsPostedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let job = jobs[indexPath.row]
        
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
        
        cell.jobTitle?.text = job.title
        cell.employmentType?.text = job.employmentType
        
        return cell
    }
    
}
