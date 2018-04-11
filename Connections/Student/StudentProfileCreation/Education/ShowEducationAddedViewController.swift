//
//  ShowEducationAddedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowEducationAddedViewController: UIViewController {
    
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education")
    var educations = [Education]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            self.educations.removeAll()
            for education in snapshot.children {
                if let data = education as? DataSnapshot {
                    if let education = Education(snapshot: data) {
                        self.educations.append(education)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            print("is\(self.educations.count)")
            
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func addNewJob(_ sender: Any) {
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ShowEducationAddedViewController: AddEducationControllerDelegate {
    
    func didAddEducation(_ education: Education) {
        educations.append(education)
        tableView.reloadData()
    }
    
}

extension ShowEducationAddedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension ShowEducationAddedViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(educations.count)
        return educations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! ShowEducationCell
        let education = educations[indexPath.row]
        cell.school?.text = education.school
        cell.studied?.text = education.studied
        cell.delegate = self
        return cell
    }
    
}

extension ShowEducationAddedViewController: EducationProfileCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                let storyboard:UIStoryboard = UIStoryboard(name: "StudentRegister", bundle: nil)
                let EditEducationViewController:EditEducationViewController = storyboard.instantiateViewController(withIdentifier: "EditEducationViewController") as! EditEducationViewController
                EditEducationViewController.education = educations[indexPath.row]
                self.navigationController?.pushViewController(EditEducationViewController, animated: true)
            }
            
            if sender.tag == 2 {
                let education = educations[indexPath.row]
                
                let refDeleteEducation = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("education").child(education.uuid!)
                
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
