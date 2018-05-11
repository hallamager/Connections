//
//  ViewStudentResponsesViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ViewAnimator

class ViewStudentResponses: UIViewController {
    
    var businesses = [Business]()
    var student: Student!
    var business: Business!
    var questionNumber: Int!
    var studentResponses = [StudentResponses]()
    var studentResponse: StudentResponses!
    var questionOnes = [QuestionOne]()
    var questionTwos = [QuestionTwo]()
    var questionThrees = [QuestionThree]()
    
    let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)")
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    let sections = ["Questions", "Answers"]
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("question two\(questionTwos.count)")
        
        navigationItem.title = student.username
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]
                
        if questionNumber == 1 {
            
                let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid).child("Answer One")
                
                ref.updateChildValues(["Status" : "Read"])
            
            print(studentResponses.count)
            
            questionTitle.text = "Question One"
        }
        
        if questionNumber == 2 {
            
            print("question two\(questionTwos.count)")
            
//                let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(student.uuid).child("Answer Two")
//
//                ref.updateChildValues(["Status" : "Read"])
            
            print(studentResponses.count)
            
            questionTitle.text = "Question Two"
        }
        
        if questionNumber == 3 {
            
            print(studentResponses.count)
            
            questionTitle.text = "Question Three"
        }
        
        ref.observe(.value, with: { snapshot in
            self.businesses.removeAll()
            if let business = Business(snapshot: snapshot) {
                self.businesses.append(business)
                self.tableView.reloadData()
                print("business \(self.businesses.count)")
            }
        })
        
        let refAnswer = Database.database().reference().child("studentResponses/\(Auth.auth().currentUser!.uid)").child(student.uuid)
        
        if self.questionNumber == 1 {
            refAnswer.child("Answer One").observeSingleEvent(of: .value) { snapshot in
                self.studentResponses.removeAll()
                if let business = StudentResponses(snapshot: snapshot) {
                    
                    self.studentResponses.append(business)
                    
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = 140
                    self.tableView.reloadData()
                    self.tableView.animateViews(animations: self.animations, delay: 0.3)
                    
                }
                
                if self.studentResponses.count == 1 {
                    
                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(self.student.uuid).child("Answer One")
                    
                    ref.updateChildValues(["Status" : "Read"])
                    
                }
                
            }
            
        }
        
        if self.questionNumber == 2 {
            refAnswer.child("Answer Two").observeSingleEvent(of: .value) { snapshot in
                self.studentResponses.removeAll()
                if let business = StudentResponses(snapshot: snapshot) {

                    self.studentResponses.append(business)
                    
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = 140
                    self.tableView.reloadData()
                    self.tableView.animateViews(animations: self.animations, delay: 0.3)
                    
                }
                
                if self.studentResponses.count == 1 {
                    
                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(self.student.uuid).child("Answer Two")
                    
                    ref.updateChildValues(["Status" : "Read"])
                    
                }
                
            }
            
        }
        
        if self.questionNumber == 3 {
            refAnswer.child("Answer Three").observeSingleEvent(of: .value) { snapshot in
                self.studentResponses.removeAll()
                if let business = StudentResponses(snapshot: snapshot) {

                    self.studentResponses.append(business)
                    
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = 140
                    self.tableView.reloadData()
                    self.tableView.animateViews(animations: self.animations, delay: 0.3)
                    
                }
                
                print("is \(self.studentResponses.count)")
                
                if self.studentResponses.count == 1 {
                    
                    let ref = Database.database().reference().child("studentResponses").child(Auth.auth().currentUser!.uid).child(self.student.uuid).child("Answer Three")
                    
                    ref.updateChildValues(["Status" : "Read"])
                    
                }
                
            }
            
        }
        
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        
    }
    
    @IBAction func nextAnswerBtn(_ sender: UIButton) {
        
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
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
