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
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid).child("specialties")
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
        
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addSkillBtn(_ sender: Any) {
        
        let ex = Specialties(data: ["Specialties": self.specialtiesInput.text!])
        ref.childByAutoId().setValue(ex.toDict())
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        presentBusinessProfileCreationViewController()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentBusinessProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let BusinessCreateProfileLandingViewController:BusinessCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "BusinessCreateProfileLandingViewController") as! BusinessCreateProfileLandingViewController
        self.present(BusinessCreateProfileLandingViewController, animated: true, completion: nil)
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
        return cell
    }
    
}
