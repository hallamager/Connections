//
//  ShowSkillsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 25/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowSkillsViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("skills")
    var skills = [Skills]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var skillInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillInput.delegate = self
        
        ref.observe(.value, with: { snapshot in
            self.skills.removeAll()
            for skill in snapshot.children {
                if let data = skill as? DataSnapshot {
                    if let skill = Skills(snapshot: data) {
                        
                        self.skills.append(skill)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            print("is\(self.skills.count)")
            
        })
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        let ex = Skills(data: ["Skill": self.skillInput.text!])
        ref.childByAutoId().setValue(ex.toDict())
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        presentStudentProfileCreationViewController()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentStudentProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
        let StudentCreateProfileLandingViewController:StudentCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "StudentCreateProfileLandingViewController") as! StudentCreateProfileLandingViewController
        self.present(StudentCreateProfileLandingViewController, animated: true, completion: nil)
    }
    
}

extension ShowSkillsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension ShowSkillsViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(skills.count)
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSkillCell") as! ShowSkillCell
        let skill = skills[indexPath.row]
        cell.skill?.text = skill.skill
        return cell
    }
    
}
