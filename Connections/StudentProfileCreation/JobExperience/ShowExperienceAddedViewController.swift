//
//  ShowExperienceAddedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowExperienceAddedViewController: UIViewController {
    
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience")
    var experiences = [Experience]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for experience in snapshot.children {
                if let data = experience as? DataSnapshot {
                    if let experience = Experience(snapshot: data) {
                        self.experiences.append(experience)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            print("is\(self.experiences.count)")
            
        })
        
    }
    
    @IBAction func addNewJob(_ sender: Any) {
        
    }
    
}

extension ShowExperienceAddedViewController: AddExperienceControllerDelegate {
    
    func didAddExperience(_ experience: Experience) {
        experiences.append(experience)
        tableView.reloadData()
    }
    
}

extension ShowExperienceAddedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EditExperienceViewController:EditExperienceViewController = storyboard.instantiateViewController(withIdentifier: "EditExperienceViewController") as! EditExperienceViewController
        EditExperienceViewController.experience = experiences[indexPath.row]
        self.present(EditExperienceViewController, animated: true, completion: nil)
        
    }
    
}

extension ShowExperienceAddedViewController: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(experiences.count)
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let experience = experiences[indexPath.row]
        cell.textLabel?.text = experience.company
        return cell
    }
    
}
