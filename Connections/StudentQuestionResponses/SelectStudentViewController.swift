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
    var student = [Student]()
    
    @IBOutlet var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudentsWhoResponsed()

        
        self.tableView.reloadData()
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func loadStudentsWhoResponsed() {
        
        let ref = Database.database().reference().child("studentResponses/\(Auth.auth().currentUser!.uid)")

        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "student")
            var students = [Student]()
            uids.forEach { uid in
                userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                    let student = Student(snapshot: snapshot)
                    students.append(student!)
                    print(students.count)
                }
            }
            
        }
            
        
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(businesses.count)
//        return businesses.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "businessSelect")!
//
//        let business = businesses[indexPath.row]
//
//        cell.textLabel?.text = business.username
//
//        cell.detailTextLabel?.text = business.industry
//
//        print(business.username)
//        print(business.industry)
//
//        return cell
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = Storyboard.instantiateViewController(withIdentifier: "BusinessQuestionsListViewController") as! BusinessQuestionsListViewController
//        vc.business = businesses[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
