//
//  SelectStudentViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SelectStudentViewController: UITableViewController {
    
    var businesses = [Business]()
    var students = [Student]()
    var student: Student!
    var studentResponses = [StudentResponses]()
    
    @IBOutlet var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudentsWhoResponsed(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            self.tableView.reloadData()
        }
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func loadStudentsWhoResponsed(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference().child("studentResponses/\(Auth.auth().currentUser!.uid)")

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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(students.count)
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "studentSelect")!

        let student = students[indexPath.row]

        cell.textLabel?.text = student.username

        cell.detailTextLabel?.text = student.headline

        print(student.username)
        print(student.headline)

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let Storyboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "ViewStudentResponses") as! ViewStudentResponses
        vc.student = students[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
