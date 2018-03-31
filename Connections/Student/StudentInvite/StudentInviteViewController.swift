//
//  StudentInviteViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import ViewAnimator
import FoldingCell

class StudentInviteViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var businesses = [Business]()
    var students = [Student]()
    var student: Student!
    var invite = [Invites]()
    var invites: Invites!
    let kCloseCellHeight: CGFloat = 170
    let kOpenCellHeight: CGFloat = 410
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadStudentsWhoGotInvited(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
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
    
    func loadStudentsWhoGotInvited(for studentUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference().child("organisedChats/\(Auth.auth().currentUser!.uid)")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "student")
            var students = [Student]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let student = Student(snapshot: snapshot)
                        students.append(student!)
                        count += 1
                        if count == uids.count {
                            completion(true, students)
                        }
                    }
                }
            } else {
                completion(true, students)
            }
            
        }
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

extension StudentInviteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as StudentInviteCell = cell else {
            return
        }
        
        let student = students[indexPath.row]
        
        let refAnswer = Database.database().reference().child("organisedChats/\(Auth.auth().currentUser!.uid)").child(student.uuid)
        
        refAnswer.observe(.value, with: { snapshot in
            if let business = Invites(snapshot: snapshot) {
                self.invite.append(business)
                cell.date.text = business.date
                cell.time.text = business.time
                cell.InviteType.text = business.inviteType
                cell.foldedInviteType.text = business.inviteType
                cell.response.text = business.response
                cell.foldedResponse.text = business.response
                cell.date2.text = business.date2
                cell.time2.text = business.time2
                
                if cell.foldedResponse.text == "Accepted" {
                    cell.foldedResponse.textColor = UIColor.green
                }
                
                if cell.response.text == "Accepted" {
                    cell.response.textColor = UIColor.green
                }
                
                if cell.foldedResponse.text == "Declined" {
                    cell.foldedResponse.textColor = UIColor.red
                }
                
                if cell.response.text == "Declined" {
                    cell.response.textColor = UIColor.red
                }
                
            }
        })
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.studentName?.text = student.username
        cell.foldedStudentName?.text = student.username
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.studentImg.image = pic
            cell.foldedStudentImg.image = pic
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

extension StudentInviteViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(students.count)
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! StudentInviteCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let student = students[indexPath.row]
        print(student.username)
        
        return cell
        
    }
    
}
