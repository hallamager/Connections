//
//  BusinessLikedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 09/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BusinessLikedViewController: UIViewController {
    
    let kCloseCellHeight: CGFloat = 160
    let kOpenCellHeight: CGFloat = 820
    let ref = Database.database().reference().child("business")
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    var businesses = [Business]()
    var counter = 0
    var recentMatchesTitle = ["Recent Matches"]

    @IBOutlet var openMenuLeft: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]
        
        
        loadRelatedBusinesses(for: Auth.auth().currentUser!.uid) { success, businesses in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        //open menu with tab bar button
        openMenuLeft.target = self.revealViewController()
        openMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    func loadRelatedBusinesses(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
        
        let ref = Database.database().reference(withPath: "studentsLiked/" + Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "business")
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
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}


extension BusinessLikedViewController: UITableViewDelegate {
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return cellHeights[indexPath.row]
        } else {
            return 100
        }
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            
            guard case let cell as BusinessLikedCell = cell else {
                return
            }
            
            let business = businesses[indexPath.row]
            
            cell.backgroundColor = .clear
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                cell.unfold(false, animated: false, completion: nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
            
            cell.companyName.text! = business.username
            cell.companyIndustry.text! = business.industry
            cell.foldingNameLabel.text! = business.username
            cell.companyHeadquarters.text! = business.businessHeadquarters
            cell.companyDescription.text! = business.description
            cell.companyWebsite.text! = business.companyWebsite
            cell.companyIndustryFolded.text! = business.industry
            cell.companySize.text! = business.companySize
            cell.companyHeadquartersFolded.text! = business.businessHeadquarters
            
            // Create a storage reference from the URL
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.companyImg.image = pic
                cell.companyImgFolded.image = pic
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
        
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
    
}

extension BusinessLikedViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            
            print(businesses.count)
            return businesses.count
            
        } else {
            
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.tableView {
            return nil
        } else {
            return recentMatchesTitle[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("did swipe \(recentMatchesTitle.count)")

        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
            
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            
            let business = businesses[indexPath.row]
            
            print(business.username)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatches") as! BusinessMatchedCell
            
            return cell
            
        }
        
    }
    
}
