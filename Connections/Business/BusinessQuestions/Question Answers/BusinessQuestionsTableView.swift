//
//  BusinessQuestionsTableView.swift
//  Connections
//
//  Created by Hallam John Ager on 05/05/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ViewAnimator

extension BusinessQuestionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
        
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if questionNumber == 1 {
                return questionOnes.count
            }
            
            if questionNumber == 2 {
                return questionTwos.count
            } else {
                return questionThrees.count
            }
            
        }
        
        return businesses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "answer") as! ShowAnswer
            
            cell.delegate = self
            
            if questionNumber == 1 {
                let questionOne = questionOnes[indexPath.row]
                cell.answer?.text = questionOne.questionOne
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentImg.image = pic
                }
                
                cell.answer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                
                return cell
            }
            
            if questionNumber == 2 {
                let questionTwo = questionTwos[indexPath.row]
                cell.answer?.text = questionTwo.questionTwo
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentImg.image = pic
                }
                
                cell.answer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                
                
                return cell
                
            } else {
                let questionThree = questionThrees[indexPath.row]
                cell.answer?.text = questionThree.questionThree
                
                let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pic = UIImage(data: data!)
                    cell.studentImg.image = pic
                }
                
                cell.answer.isScrollEnabled = false
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "question") as! ShowQuestion
        
        if questionNumber == 1 {
            cell.question.text = business.questionOne
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.companyImg.image = pic
            }
            
            cell.question.translatesAutoresizingMaskIntoConstraints = true
            cell.question.sizeToFit()
            cell.question.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        
        if questionNumber == 2 {
            cell.question.text = business.questionTwo
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.companyImg.image = pic
            }
            
            cell.question.translatesAutoresizingMaskIntoConstraints = true
            cell.question.sizeToFit()
            cell.question.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        
        if questionNumber == 3 {
            cell.question.text = business.questionThree
            
            let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                cell.companyImg.image = pic
            }
            
            cell.question.translatesAutoresizingMaskIntoConstraints = true
            cell.question.sizeToFit()
            cell.question.isScrollEnabled = false
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        
        return cell
        
    }
    
}

extension BusinessQuestionsListViewController: RemoveAnswerCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if getCurrentCellIndexPath(sender) != nil {
            
            if sender.tag == 1 {
                
                if questionNumber == 1 {
                    
                    let refDeleteAnswer = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer One")
                    
                    refDeleteAnswer.child("Question One Answer").removeValue()
                    
                }
                
                if questionNumber == 2 {
                    
                    let refDeleteAnswer = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer Two")
                    
                    refDeleteAnswer.child("Question Two Answer").removeValue()
                    
                }
                
                if questionNumber == 3 {
                                        
                    let refDeleteAnswer = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer Three")
                    
                    refDeleteAnswer.child("Question Three Answer").removeValue()
                    
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
