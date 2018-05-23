//
//  BusinessJobsViewController.swift
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

class BusinessJobsViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noJobsAlert: UILabel!
    
    var business: Business!
    let ref = Database.database().reference().child("business").child("valid")
    var businesses = [Business]()
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if businesses.count == 0 {
            self.noJobsAlert.text! = "You haven't matched with any businesses yet. Get swiping to be able to view business jobs."
            print("true")
        } else {
            self.noJobsAlert.text! = ""
        }
        
        loadRelatedBusinesses(for: Auth.auth().currentUser!.uid) { success, businesses in
            self.businesses = businesses
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
        }
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
    }
    
    func loadRelatedBusinesses(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
        
        let ref = Database.database().reference(withPath: "matches/" + Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "business").child("valid")
            var businesses = [Business]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let business = Business(snapshot: snapshot)
                        businesses.append(business!)
                        count += 1
                        if count == uids.count {
                            completion(true, businesses)
                        }
                    }
                }
            } else {
                completion(true, businesses)
            }
        }
    }
    
}

extension BusinessJobsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let business = businesses[indexPath.row]
        
        guard business.hasJobs else { return }
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
        let BusinessShowJobsViewController:BusinessShowJobsViewController = storyboard.instantiateViewController(withIdentifier: "BusinessShowJobsViewController") as! BusinessShowJobsViewController
        self.navigationController?.pushViewController(BusinessShowJobsViewController, animated: true)
        BusinessShowJobsViewController.business = business
        
    }
    
}

extension BusinessJobsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(businesses.count)
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessJobs", for: indexPath) as! BusinessJobCell
        
        let business = businesses[indexPath.row]
        
        cell.companyName?.text = business.username
        cell.jobsPosted?.text = "\(business.numberOfJobs) posted"
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.companyImg.image = pic
        }
        
        return cell
        
    }
    
}
