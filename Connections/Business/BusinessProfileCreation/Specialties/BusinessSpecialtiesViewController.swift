//
//  BusinessSpecialtiesViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessSpecialtiesViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Database.database().reference().child("business").child("pending").child(Auth.auth().currentUser!.uid).child("specialties")
    var specialties = [Specialties]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var specialtiesInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specialtiesInput.delegate = self
        
        ref.observe(.value, with: { snapshot in
            self.specialties.removeAll()
            for specialties in snapshot.children {
                if let data = specialties as? DataSnapshot {
                    if let specialties = Specialties(snapshot: data) {
                        
                        self.specialties.append(specialties)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            print("is\(self.specialties.count)")
            
        })
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        let ex = Specialties(data: ["Specialties": self.specialtiesInput.text!])
        ref.childByAutoId().setValue(ex.toDict())
        
        specialtiesInput.text! = ""
        
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
        
        presentBusinessProfileCreationViewController()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension BusinessSpecialtiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension BusinessSpecialtiesViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(specialties.count)
        return specialties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialtiesCell") as! SpecialtiesCell
        let specialty = specialties[indexPath.row]
        cell.specialties?.text = specialty.specialties
        cell.delegate = self
        return cell
    }
    
}

extension BusinessSpecialtiesViewController: SpecialtiesCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                let specialtie = specialties[indexPath.row]
                
                let refDeleteJobs = Database.database().reference().child("business/pending/\(Auth.auth().currentUser!.uid)").child("specialties").child(specialtie.uuid!)
                
                refDeleteJobs.removeValue()
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
