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
import ViewAnimator

class BusinessLikedViewController: UIViewController {
    
    let kCloseCellHeight: CGFloat = 160
    let kOpenCellHeight: CGFloat = 820
    let ref = Database.database().reference().child("business")
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    var businesses = [Business]()
    var matchedBusinesses = [Business]()
    var specialties = [Specialties]()
    var recentMatchesTitle = ["Recent Matches"]
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    let animationsZoom = [AnimationType.zoom(scale: 0.5)]


    @IBOutlet var openMenuLeft: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noRecentMatches: UILabel!
    @IBOutlet weak var noBusinessesLiked: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]
        
        
        loadRelatedBusinesses(for: Auth.auth().currentUser!.uid) { success, likedBusinesses in
            self.businesses = likedBusinesses
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            
            if likedBusinesses.count == 0 {
                self.noBusinessesLiked.text! = "You haven't liked any businesses yet. Get swiping!"
                print("true")
            } else {
                self.noBusinessesLiked.text! = ""
            }
            
        }
        
        loadMatches(for: Auth.auth().currentUser!.uid) { success, matchedBusinesses in
            self.matchedBusinesses = matchedBusinesses
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates({
                self.collectionView.animateViews(animations: self.animationsZoom)
            }, completion: nil)
            
            if matchedBusinesses.count == 0 {
                self.noRecentMatches.text! = "You have no recent matches. Get swiping!"
                print("true")
            } else {
                self.noRecentMatches.text! = ""
            }
            
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
        cell.jobsPosted?.text = "\(business.numberOfJobs) Jobs available"
        
        if business.jobs.count == 1 {
            cell.jobsPosted?.text = "\(business.numberOfJobs) Job available"
        }
        
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

extension BusinessLikedViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        print("business \(businesses.count)")
        return businesses.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BusinessLikedCell
            
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            
            let business = businesses[indexPath.row]
        
            let refSpecialties = Database.database().reference().child("business").child(business.uuid).child("specialties")

            refSpecialties.observe(.value, with: { snapshot in
                self.specialties.removeAll()
                for specialties in snapshot.children {
                    if let data = specialties as? DataSnapshot {
                        if let specialties = Specialties(snapshot: data) {
                            
                            self.specialties.append(specialties)
                        }
                    }
                }
                
                cell.specialtiesCollectionView.reloadData()
                
                print("is\(self.specialties.count)")
                
            })
            
            cell.delegate = self
            
            print(business.username)
            
            return cell
        
    }
    
}

extension BusinessLikedViewController: ViewJobCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                
                let revealViewController:SWRevealViewController = self.revealViewController()
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
                let desController = mainStoryboard.instantiateViewController(withIdentifier: "BusinessSelectViewController") as! BusinessSelectViewController
                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                
                revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                
            }
            
            if sender.tag == 2 {
                
                let business = businesses[indexPath.row]
                
                guard business.hasJobs else { return }
                
                let storyboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
                let BusinessShowJobsViewController:BusinessShowJobsViewController = storyboard.instantiateViewController(withIdentifier: "BusinessShowJobsViewController") as! BusinessShowJobsViewController
                self.navigationController?.pushViewController(BusinessShowJobsViewController, animated: true)
                BusinessShowJobsViewController.business = business
                
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
