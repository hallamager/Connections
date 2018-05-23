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
    @IBOutlet weak var noInvitesAlert: UILabel!
    
    var businesses = [Business]()
    var students = [Student]()
    var student: Student!
    var invite = [Invites]()
    var invites: Invites!
    let kCloseCellHeight: CGFloat = 170
    let kOpenCellHeight: CGFloat = 415
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if students.count == 0 {
            self.noInvitesAlert.text! = "You haven't sent any invites yet. To do so, view the students you've liked and organise an interview."
            print("true")
        } else {
            self.noInvitesAlert.text! = ""
        }
        
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
            
            let userRef = Database.database().reference(withPath: "student").child("valid")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? (tag: Int, student: Student) else { return }
        
        let vc = segue.destination as! OrganiseChatViewController
        vc.student = sender.student
        
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
                cell.firstDateResponse.text = business.responseFirstDate
                cell.secondDateResponse.text = business.responseSecondDate
                
                if cell.foldedResponse.text == "Date Accepted" {
                    cell.foldedResponse.textColor = UIColor(red: 13/255, green: 97/255, blue: 40/255, alpha: 1.0)
                }
                
                if cell.firstDateResponse.text == "Date Accepted" {
                    cell.firstDateResponse.textColor = UIColor(red: 13/255, green: 97/255, blue: 40/255, alpha: 1.0)
                }
                
                if cell.firstDateResponse.text == "Declined" {
                    cell.firstDateResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.firstDateResponse.text == "Cancelled" {
                    cell.firstDateResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.secondDateResponse.text == "Date Accepted" {
                    cell.secondDateResponse.textColor = UIColor(red: 13/255, green: 97/255, blue: 40/255, alpha: 1.0)
                }
                
                if cell.secondDateResponse.text == "Declined" {
                    cell.secondDateResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.secondDateResponse.text == "Cancelled" {
                    cell.secondDateResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.foldedResponse.text == "Different Dates Requested" {
                    cell.foldedResponse.textColor = UIColor.darkGray
                }
                
                if cell.response.text == "Different Dates Requested" {
                    cell.response.textColor = UIColor.darkGray
                }
                
                if cell.response.text == "Date Accepted" {
                    cell.response.textColor = UIColor(red: 13/255, green: 97/255, blue: 40/255, alpha: 1.0)
                }
                
                if cell.foldedResponse.text == "Declined" {
                    cell.foldedResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.foldedResponse.text == "Cancelled" {
                    cell.foldedResponse.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.response.text == "Declined" {
                    cell.response.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
                }
                
                if cell.response.text == "Cancelled" {
                    cell.response.textColor = UIColor(red: 199/255, green: 18/255, blue: 46/255, alpha: 1.0)
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
        
        cell.student = student
        cell.delegate = self
        
        return cell
        
    }
    
}

extension StudentInviteViewController: RearrangeCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 2 {
                
                let student = students[indexPath.row]
                
                let ref = Database.database().reference().child("organisedChats").child(student.uuid).child(Auth.auth().currentUser!.uid)
                
                let refBusiness = Database.database().reference().child("organisedChats").child(Auth.auth().currentUser!.uid).child(student.uuid)
                
                ref.updateChildValues(["Response": "Cancelled", "First Date Response": "Cancelled", "Second Date Response": "Cancelled"])
                
                refBusiness.updateChildValues(["Response": "Cancelled", "First Date Response": "Cancelled", "Second Date Response": "Cancelled"])
                
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
    
    func selected(for student: Student) {
        print(student)
        
        performSegue(withIdentifier: "rearrangeChat", sender: (tag: 1, student: student))
    }
    
}
