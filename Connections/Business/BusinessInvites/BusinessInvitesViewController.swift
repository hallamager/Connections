//
//  BusinessInvitesViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 28/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ViewAnimator
import FoldingCell

class BusinessInvitesViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var businesses = [Business]()
    var students = [Student]()
    var student: Student!
    var invite = [Invites]()
    var invites: Invites!
    let kCloseCellHeight: CGFloat = 130
    let kOpenCellHeight: CGFloat = 340
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadBusinessesWhoInvited(for: Auth.auth().currentUser!.uid) { success, businesses in
            self.businesses = businesses
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
        }
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    func loadBusinessesWhoInvited(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
        
        let ref = Database.database().reference().child("organisedChats/\(Auth.auth().currentUser!.uid)")
        
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

extension BusinessInvitesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as BusinessInvitesCell = cell else {
            return
        }
        
        let business = businesses[indexPath.row]
        
        let refAnswer = Database.database().reference().child("organisedChats/\(Auth.auth().currentUser!.uid)").child(business.uuid)
        
        refAnswer.observeSingleEvent(of: .value, with: { snapshot in
            if let business = Invites(snapshot: snapshot) {
                self.invite.append(business)
                cell.date.text = business.date
                cell.time.text = business.time
                cell.InviteType.text = business.inviteType
                cell.foldedInviteType.text = business.inviteType
            }
        })
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.companyName?.text = business.username
        cell.foldedCompanyName?.text = business.username
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.companyImg.image = pic
            cell.foldedCompanyImg.image = pic
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

extension BusinessInvitesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(businesses.count)
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BusinessInvitesCell
        
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let business = businesses[indexPath.row]
        print(business.username)
        
        return cell
        
    }
    
}

extension BusinessInvitesViewController: YourCellDelegate {
    
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
}
