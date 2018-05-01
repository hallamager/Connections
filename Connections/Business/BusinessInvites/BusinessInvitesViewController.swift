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
    let kCloseCellHeight: CGFloat = 165
    let kOpenCellHeight: CGFloat = 850
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
        
        refAnswer.observe(.value, with: { snapshot in
            if let business = Invites(snapshot: snapshot) {
                self.invite.append(business)
                cell.date.text = business.date
                cell.date2.text = business.date2
                cell.time.text = business.time
                cell.time2.text = business.time2
                cell.InviteType.text = business.inviteType
                cell.foldedInviteType.text = business.inviteType
                cell.response.text = business.response
                cell.foldedResponse.text = business.response
                cell.firstDateConfirmedLabel.text = business.responseFirstDate
                cell.secondDateConfirmedLabel.text = business.responseSecondDate
                cell.inviteLocation.text = business.location
                cell.moreInfo.text = business.moreInfo
                
                if cell.foldedResponse.text == "Date Accepted" {
                    cell.foldedResponse.textColor = UIColor.green
                }
                
                if cell.foldedResponse.text == "Different Dates Requested" {
                    cell.foldedResponse.textColor = UIColor.darkGray
                }
                
                if cell.response.text == "Different Dates Requested" {
                    cell.response.textColor = UIColor.darkGray
                }
            
                if cell.response.text == "Date Accepted" {
                    cell.response.textColor = UIColor.green
                }
                
                if cell.foldedResponse.text == "Declined" {
                    cell.foldedResponse.textColor = UIColor.red
                }
                
                if cell.foldedResponse.text == "Cancelled" {
                    cell.foldedResponse.textColor = UIColor.red
                }
                
                if cell.response.text == "Declined" {
                    cell.response.textColor = UIColor.red
                }
                
                if cell.response.text == "Cancelled" {
                    cell.response.textColor = UIColor.red
                }
                
                if cell.firstDateConfirmedLabel.text == "Date Accepted" {
                    cell.firstDateConfirmedLabel.textColor = UIColor.green
                }
                
                if cell.firstDateConfirmedLabel.text == "Declined" {
                    cell.firstDateConfirmedLabel.textColor = UIColor.red
                }
                
                if cell.firstDateConfirmedLabel.text == "Cancelled" {
                    cell.firstDateConfirmedLabel.textColor = UIColor.red
                }
                
                if cell.firstDateConfirmedLabel.text == "Pending Response" {
                    cell.firstDateConfirmedLabel.textColor = UIColor.darkGray
                }
                
                if cell.secondDateConfirmedLabel.text == "Date Accepted" {
                    cell.secondDateConfirmedLabel.textColor = UIColor.green
                }
                
                if cell.secondDateConfirmedLabel.text == "Declined" {
                    cell.secondDateConfirmedLabel.textColor = UIColor.red
                }
                
                if cell.secondDateConfirmedLabel.text == "Cancelled" {
                    cell.secondDateConfirmedLabel.textColor = UIColor.red
                }
                
                if cell.secondDateConfirmedLabel.text == "Pending Response" {
                    cell.secondDateConfirmedLabel.textColor = UIColor.darkGray
                }
                
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

extension BusinessInvitesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(businesses.count)
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BusinessInvitesCell
        
        cell.delegate = self
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let business = businesses[indexPath.row]
        print(business.username)
        
        return cell
        
    }
    
}

extension BusinessInvitesViewController: InviteCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                
                let business = businesses[indexPath.row]
                print("is\(business.username)")
                
                let ref = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(business.uuid)
                
                let refBusiness = Database.database().reference().child("organisedChats").child(business.uuid).child(Auth.auth().currentUser!.uid)
                
                ref.updateChildValues(["Response": "Declined"])
                
                refBusiness.updateChildValues(["Response": "Declined"])
                
                ref.updateChildValues(["First Date Response": "Declined"])
                
                refBusiness.updateChildValues(["First Date Response": "Declined"])
                
                ref.updateChildValues(["Second Date Response": "Declined"])
                
                refBusiness.updateChildValues(["Second Date Response": "Declined"])
                
            }
            
            if sender.tag == 2 {
                
                let business = businesses[indexPath.row]
                print("is\(business.username)")
                
                let ref = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(business.uuid)
                
                let refBusiness = Database.database().reference().child("organisedChats").child(business.uuid).child(Auth.auth().currentUser!.uid)
                
                ref.updateChildValues(["Response": "Date Accepted"])
                
                refBusiness.updateChildValues(["Response": "Date Accepted"])
                
                ref.updateChildValues(["Second Date Response": "Date Accepted"])
                
                refBusiness.updateChildValues(["Second Date Response": "Date Accepted"])
                
                ref.updateChildValues(["First Date Response": "Declined"])
                
                refBusiness.updateChildValues(["First Date Response": "Declined"])
                
            }
            
            if sender.tag == 3 {
                
                let business = businesses[indexPath.row]
                print("is\(business.username)")
                
                let ref = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(business.uuid)
                
                let refBusiness = Database.database().reference().child("organisedChats").child(business.uuid).child(Auth.auth().currentUser!.uid)
                
                ref.updateChildValues(["Response": "Date Accepted"])
                
                refBusiness.updateChildValues(["Response": "Date Accepted"])
                
                ref.updateChildValues(["First Date Response": "Date Accepted"])
                
                refBusiness.updateChildValues(["First Date Response": "Date Accepted"])
                
                ref.updateChildValues(["Second Date Response": "Declined"])
                
                refBusiness.updateChildValues(["Second Date Response": "Declined"])
                
            }
            
            if sender.tag == 4 {
                
                let business = businesses[indexPath.row]
                
                let ref = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(business.uuid)
                
                let refBusiness = Database.database().reference().child("organisedChats").child(business.uuid).child(Auth.auth().currentUser!.uid)
                
                ref.updateChildValues(["Response": "Different Dates Requested"])
                
                refBusiness.updateChildValues(["Response": "Different Dates Requested"])
                
                ref.updateChildValues(["Second Date Response": "Declined"])
                
                refBusiness.updateChildValues(["Second Date Response": "Declined"])
                
                ref.updateChildValues(["First Date Response": "Declined"])
                
                refBusiness.updateChildValues(["First Date Response": "Declined"])
                
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
