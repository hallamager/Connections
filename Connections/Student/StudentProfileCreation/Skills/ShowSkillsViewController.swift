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
    
    let refPending = Database.database().reference().child("student").child("pending").child(Auth.auth().currentUser!.uid).child("skills")
    let refValid = Database.database().reference().child("student").child("valid").child(Auth.auth().currentUser!.uid).child("skills")
    let refCheckValid = Database.database().reference().child("student").child("valid")
    var skills = [Skills]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var skillInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        skillInput.delegate = self
        
        refCheckValid.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                self.refValid.observe(.value, with: { snapshot in
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
                
            } else {
                
                self.refPending.observe(.value, with: { snapshot in
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
            
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        let ex = Skills(data: ["Skill": self.skillInput.text!])
        
        refCheckValid.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                self.refValid.childByAutoId().setValue(ex.toDict())
                
            } else {
                
                self.refPending.childByAutoId().setValue(ex.toDict())
                
            }
            
        }
        
        skillInput.text! = ""

    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
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
        cell.delegate = self
        return cell
    }
    
}

extension ShowSkillsViewController: DeleteSkillsCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
            
                let skill = skills[indexPath.row]
                
                refCheckValid.observeSingleEvent(of: .value) { snapshot in
                    
                    if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                        
                        let refDeleteSkill = Database.database().reference().child("student/valid/\(Auth.auth().currentUser!.uid)").child("skills").child(skill.uuid!)
                        
                        refDeleteSkill.removeValue()
                        
                    } else {
                        
                        let refDeleteSkill = Database.database().reference().child("student/pending/\(Auth.auth().currentUser!.uid)").child("skills").child(skill.uuid!)
                        
                        refDeleteSkill.removeValue()
                        
                    }
                    
                }
                
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
