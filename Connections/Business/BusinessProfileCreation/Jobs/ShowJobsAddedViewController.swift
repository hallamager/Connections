//
//  ShowJobsAddedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 02/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowJobsAddedViewController: UIViewController {
    
    let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs")
    var jobs = [Job]()
    var job: Job!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for job in snapshot.children {
                if let data = job as? DataSnapshot {
                    if let job = Job(snapshot: data) {
                        self.jobs.append(job)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            print("is\(self.jobs.count)")
            
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func addNewJob(_ sender: Any) {
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessCreateProfileLandingViewController:BusinessCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "BusinessCreateProfileLandingViewController") as! BusinessCreateProfileLandingViewController
        self.present(BusinessCreateProfileLandingViewController, animated: true, completion: nil)
    }
}

extension ShowJobsAddedViewController: AddJobsControllerDelegate {
    
    func didAddJobs(_ job: Job) {
        jobs.append(job)
        tableView.reloadData()
    }
    
}

extension ShowJobsAddedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let EditJobsViewController:EditJobsViewController = storyboard.instantiateViewController(withIdentifier: "EditJobsViewController") as! EditJobsViewController
        EditJobsViewController.job = jobs[indexPath.row]
        self.present(EditJobsViewController, animated: true, completion: nil)
        
    }
    
}

extension ShowJobsAddedViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(jobs.count)
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ShowJobsCell
        let job = jobs[indexPath.row]
        cell.jobTitle?.text = job.title
        cell.employmentType?.text = job.employmentType
        return cell
    }
    
}
