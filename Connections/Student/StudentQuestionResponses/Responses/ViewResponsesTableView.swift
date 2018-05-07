//
//  ViewResponsesTableView.swift
//  Connections
//
//  Created by Hallam John Ager on 06/05/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ViewAnimator

extension ViewStudentResponses: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
        
    }
    
}

extension ViewStudentResponses: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if questionNumber == 1 {
                return studentResponses.count
            }
            
            if questionNumber == 2 {
                return studentResponses.count
            } else {
                return studentResponses.count
            }
            
        }
        
        return businesses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "answer") as! ShowAnswer
            
            cell.delegate = self
            
            if questionNumber == 1 {
                let studentResponse = studentResponses[indexPath.row]
                cell.studentAnswer?.text = studentResponse.questionOne
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentProfilePic.image = pic
                }
                
                cell.studentAnswer.translatesAutoresizingMaskIntoConstraints = true
                cell.studentAnswer.sizeToFit()
                cell.studentAnswer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                
                return cell
            }
            
            if questionNumber == 2 {
                let studentResponse = studentResponses[indexPath.row]
                cell.studentAnswer?.text = studentResponse.questionTwo
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentProfilePic.image = pic
                }
                
                cell.studentAnswer.translatesAutoresizingMaskIntoConstraints = true
                cell.studentAnswer.sizeToFit()
                cell.studentAnswer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                
                return cell
                
            } else {
                let studentResponse = studentResponses[indexPath.row]
                cell.studentAnswer?.text = studentResponse.questionThree
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentProfilePic.image = pic
                }
                
                cell.studentAnswer.translatesAutoresizingMaskIntoConstraints = true
                cell.studentAnswer.sizeToFit()
                cell.studentAnswer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "question") as! ShowQuestion
        
        if questionNumber == 1 {
            
            let business = businesses[indexPath.row]
            cell.businessQuestion?.text = business.questionOne
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.businessImg.image = pic
            }
            
            cell.businessQuestion.translatesAutoresizingMaskIntoConstraints = true
            cell.businessQuestion.sizeToFit()
            cell.businessQuestion.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            
            return cell
        }
        
        if questionNumber == 2 {
            
            let business = businesses[indexPath.row]
            cell.businessQuestion?.text = business.questionTwo
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.businessImg.image = pic
            }
            
            cell.businessQuestion.translatesAutoresizingMaskIntoConstraints = true
            cell.businessQuestion.sizeToFit()
            cell.businessQuestion.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        
        if questionNumber == 3 {
            
            let business = businesses[indexPath.row]
            cell.businessQuestion?.text = business.questionThree
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.businessImg.image = pic
            }

            cell.businessQuestion.translatesAutoresizingMaskIntoConstraints = true
            cell.businessQuestion.sizeToFit()
            cell.businessQuestion.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        
        return cell
        
    }
    
}

extension ViewStudentResponses: RemoveAnswerCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if getCurrentCellIndexPath(sender) != nil {
            
            if sender.tag == 1 {
                
                if questionNumber == 1 {
                    
                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid).child("Answer One")
                    
                    ref.updateChildValues(["Status" : "Liked"])
                    
                    print("tapped")
                }
                
                if questionNumber == 2 {
                    
                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid).child("Answer Two")
                    
                    ref.updateChildValues(["Status" : "Liked"])
                    
                    print("tapped")
                }
                
                if questionNumber == 3 {

                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid).child("Answer Three")
                    
                    ref.updateChildValues(["Status" : "Liked"])
                    
                    print("tapped")
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
