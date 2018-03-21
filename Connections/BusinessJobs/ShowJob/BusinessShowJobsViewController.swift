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
    
    let ref = Database.database().reference().child("business")
    var businesses = [Business]()
    var jobs = [Job]()
    let kCloseCellHeight: CGFloat = 130
    let kOpenCellHeight: CGFloat = 340
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    var business: Business!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = business.username
        
//        loadRelatedBusinesses(for: Auth.auth().currentUser!.uid) { success, businesses in
//            self.businesses = businesses
//            self.tableView.reloadData()
//            self.tableView.animateViews(animations: self.animations, delay: 0.3)
//        }
        
        let refJobs = Database.database().reference().child("business").child(business.uuid).child("Jobs")

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
    
//    func loadRelatedBusinesses(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
//
//        let ref = Database.database().reference(withPath: "matches/" + Auth.auth().currentUser!.uid)
//        ref.observeSingleEvent(of: .value) { snapshot in
//
//            var uids = [String]()
//            for child in snapshot.children {
//                let userData = child as! DataSnapshot
//                uids.append(userData.key)
//            }
//
//            let userRef = Database.database().reference(withPath: "business")
//            var businesses = [Business]()
//            var count = 0
//            if uids.count != 0 {
//                uids.forEach { uid in
//                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
//                        let business = Business(snapshot: snapshot)
//                        businesses.append(business!)
//                        count += 1
//                        if count == uids.count {
//                            completion(true, businesses)
//                        }
//                    }
//                }
//            } else {
//                completion(true, businesses)
//            }
//        }
//    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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

extension BusinessShowJobsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showBusinessJobs", for: indexPath) as! SelectJobCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let job = jobs[indexPath.row]
        print(job.title)
        
        return cell
        
    }
    
}
