//
//  BusinessShowJobsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 21/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ViewAnimator
import FoldingCell

class BusinessShowJobsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference().child("business").child("valid")
    var businesses = [Business]()
    var jobs = [Job]()
    let kCloseCellHeight: CGFloat = 130
    let kOpenCellHeight: CGFloat = 540
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    var business: Business!
    var job: Job!
    var counter = 0
    var skillRequired = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = business.username
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!]
        
        let refJobs = Database.database().reference().child("business").child("valid").child(business.uuid).child("Jobs")

        refJobs.observeSingleEvent(of: .value, with: { snapshot in
            for job in snapshot.children {
                if let data = job as? DataSnapshot {
                    if let job = Job(snapshot: data) {
                        self.jobs.append(job)
                    }
                }
            }

            print("is\(self.jobs.count)")
            
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)

        })
        
        setup()
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        
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
        
        appliedBtn(self.jobs[counter])
        
    }
    
    func appliedBtn(_ job: Job) {
        
        let refApply = Database.database().reference().child("jobsApplied").child(business.uuid).child(job.uuid!)
        
        let apply = [Auth.auth().currentUser!.uid: true]
        
        refApply.updateChildValues(apply)
                
    }
    
}

extension BusinessShowJobsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as SelectJobCell = cell else {
            return
        }
        
        let job = jobs[indexPath.row]
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.businessName?.text = job.title
        cell.employmentType?.text = job.employmentType
        cell.foldedBusinessName?.text = job.title
        cell.foldedEmploymentType?.text = job.employmentType
        cell.jobDescription?.text = job.description
        cell.jobSalary?.text = job.salary
        cell.jobLocation?.text = job.location
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.businessImg.image = pic
            cell.foldedBusinessImg.image = pic
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

extension BusinessShowJobsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showBusinessJobs", for: indexPath) as! SelectJobCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let job = jobs[indexPath.row]
        
        let ref = Database.database().reference().child("business").child("valid").child(business.uuid).child("Jobs").child(job.uuid!).child("skillsRequired")
        
        ref.observe(.value, with: { snapshot in
            
            self.skillRequired.removeAll()
            
            for group in snapshot.children {
                self.skillRequired.append((group as AnyObject).key)
            }
            print(self.skillRequired)
            
            cell.skillsRequiredCollectionView.reloadData()
            
        })
        
        let refHasApplied = Database.database().reference().child("jobsApplied").child(business.uuid).child(job.uuid!)
        
        refHasApplied.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                cell.applyBtn.setTitle("Succesfully Applied", for: .normal)
                cell.applyBtn.isEnabled = false
                
                cell.foldedAppliedImg.image = UIImage(named: "appliedImg")
                cell.appliedImg.image = UIImage(named: "appliedImg")
                
            }
            
        })
        
        print(job.title)
        
        return cell
        
    }
    
}
