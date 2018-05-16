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
    
    let ref = Database.database().reference().child("student/pending/\(Auth.auth().currentUser!.uid)").child("experience")
    var experiences = [Experience]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ref.observe(.value, with: { snapshot in
            self.experiences.removeAll()
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
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    @IBAction func addNewJob(_ sender: Any) {
        
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
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}

extension ShowExperienceAddedViewController: AddExperienceControllerDelegate {
    
    func didAddExperience(_ experience: Experience) {
        experiences.append(experience)
        tableView.reloadData()
    }
    
}

extension ShowExperienceAddedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ShowExperienceCell
        let experience = experiences[indexPath.row]
        cell.jobTitle?.text = experience.title
        cell.jobCompany?.text = experience.company
        cell.delegate = self
        return cell
    }
    
}

extension ShowExperienceAddedViewController: ExperienceProfileCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
                let EditExperienceViewController:EditExperienceViewController = storyboard.instantiateViewController(withIdentifier: "EditExperienceViewController") as! EditExperienceViewController
                EditExperienceViewController.experience = experiences[indexPath.row]
                self.navigationController?.pushViewController(EditExperienceViewController, animated: true)
            }
            
            if sender.tag == 2 {
                let experience = experiences[indexPath.row]
                
                let refDeleteEducation = Database.database().reference().child("student/pending/\(Auth.auth().currentUser!.uid)").child("experience").child(experience.uuid!)
                
                refDeleteEducation.removeValue()
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
