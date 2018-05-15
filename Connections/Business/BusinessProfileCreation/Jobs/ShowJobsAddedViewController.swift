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
    
    let ref = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("Jobs")
    var jobs = [Job]()
    var job: Job!
    
    @IBOutlet var tableView: UITableView!
    
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
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        self.navigationController?.popToRootViewController(animated: true)
        
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
        cell.delegate = self
        return cell
    }
    
}

extension ShowJobsAddedViewController: JobCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
                let EditJobsViewController:EditJobsViewController = storyboard.instantiateViewController(withIdentifier: "EditJobsViewController") as! EditJobsViewController
                EditJobsViewController.job = jobs[indexPath.row]
                self.navigationController?.pushViewController(EditJobsViewController, animated: true)
            }
            
            if sender.tag == 2 {
                let job = jobs[indexPath.row]
                
                let refDeleteJobs = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!)
                
                refDeleteJobs.removeValue()
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
    
}
