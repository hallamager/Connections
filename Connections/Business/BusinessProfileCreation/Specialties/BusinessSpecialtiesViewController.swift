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
    
    let refPending = Database.database().reference().child("business").child("pending").child(Auth.auth().currentUser!.uid).child("specialties")
    let refValid = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid).child("specialties")
    let refCheckValid = Database.database().reference().child("business").child("valid")
    var specialties = [Specialties]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var specialtiesInput: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specialtiesInput.delegate = self
        
        refCheckValid.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                print("hello valid")
                
                self.refValid.observe(.value, with: { snapshot in
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
                
            } else {
                
                print("hello pending")
                
                self.refPending.observe(.value, with: { snapshot in
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
                
            }
            
        })
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        if specialtiesInput.text == "" {
            print("nil")
            return
        }
        
        refCheckValid.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                
                let ex = Specialties(data: ["Specialties": self.specialtiesInput.text!])
                self.refValid.childByAutoId().setValue(ex.toDict())
                self.specialtiesInput.text! = ""
                
            } else {
                
                let ex = Specialties(data: ["Specialties": self.specialtiesInput.text!])
                self.refPending.childByAutoId().setValue(ex.toDict())
                self.specialtiesInput.text! = ""
                
            }
            
        }
        
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
                
                refCheckValid.observeSingleEvent(of: .value) { snapshot in
                    
                    if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                        
                        let refDeleteJobs = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("specialties").child(specialtie.uuid!)
                        
                        refDeleteJobs.removeValue()
                        
                    } else {
                        
                        let refDeleteJobs = Database.database().reference().child("business/pending/\(Auth.auth().currentUser!.uid)").child("specialties").child(specialtie.uuid!)
                        
                        refDeleteJobs.removeValue()
                        
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
