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
        
        self.navigationController?.navigationBar.isTranslucent = false
        
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
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func skill(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -180, up: true)
    }
    
    @IBAction func skillLeave(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -180, up: false)
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        let ex = Skills(data: ["Skill": self.skillInput.text!])
        ref.childByAutoId().setValue(ex.toDict())
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                
                let refDeleteSkills = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("skills").child(skill.uuid!)
                
                refDeleteSkills.removeValue()
                
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
