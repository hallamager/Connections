//
//  BusinessQuestionsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ViewAnimator
import IQKeyboardManagerSwift

class BusinessQuestionsListViewController: UIViewController, UITextFieldDelegate {
    
    var business: Business!
    var businesses = [Business]()
    var questionNumber: Int!
    var questionOnes = [QuestionOne]()
    var questionTwos = [QuestionTwo]()
    var questionThrees = [QuestionThree]()
 
    let ref = Database.database().reference().child("studentResponses")
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    let sections = ["Questions", "Answers"]
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendAnswer: UIButtonStyles!
    
    @IBAction func nextQuestionButton(_ sender: UIButton) {
        
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
        
        guard let textField = textField.text, !textField.isEmpty else {
            return
        }
        
        if questionNumber == 1 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer One")
            let ex = QuestionOne(data: ["Question One Answer": self.textField.text!, "Status": "Sent"])
            refQuestion.updateChildValues(ex.toDict1())
        }
        
        if questionNumber == 2 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer Two")
            let ex = QuestionTwo(data: ["Question Two Answer": self.textField.text!, "Status": "Sent"])
            refQuestion.updateChildValues(ex.toDict2())
        }
        
        if questionNumber == 3 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid).child("Answer Three")
            let ex = QuestionThree(data: ["Question Three Answer": self.textField.text!, "Status": "Sent"])
            refQuestion.updateChildValues(ex.toDict3())
        }

        self.textField.text! = ""
        self.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let ref = Database.database().reference().child("business").child("valid").child(business.uuid)
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [BusinessQuestionsListViewController.self]
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(BusinessQuestionsListViewController.self)
        
        ref.observe(.value, with: { snapshot in
            if let business = Business(snapshot: snapshot) {
                self.businesses.append(business)
                self.tableView.reloadData()
                print("business \(self.businesses.count)")
            }
        })
        
        let refAnswer = Database.database().reference().child("studentResponses/\(business.uuid)").child(Auth.auth().currentUser!.uid)
        
        if self.questionNumber == 1 {
            
            refAnswer.child("Answer One").observe(.value, with: { snapshot in

                self.questionOnes.removeAll()
                if let questionOne = QuestionOne(snapshot: snapshot) {
                    self.questionOnes.append(questionOne)
                }
                
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 140
                self.tableView.reloadData()
                self.tableView.animateViews(animations: self.animations, delay: 0.3)
                print("is1\(self.questionOnes.count)")
                print("is2\(self.questionTwos.count)")
                print("is3\(self.questionThrees.count)")
                
            })
            
        }
        
        if self.questionNumber == 2 {

            refAnswer.child("Answer Two").observe(.value, with: { snapshot in
                
                self.questionTwos.removeAll()
                if let questionTwo = QuestionTwo(snapshot: snapshot) {
                    self.questionTwos.append(questionTwo)
                }
                

                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 140
                self.tableView.reloadData()
                self.tableView.animateViews(animations: self.animations, delay: 0.3)
                print("is1\(self.questionOnes.count)")
                print("is2\(self.questionTwos.count)")
                print("is3\(self.questionThrees.count)")
            })
            
        }
        
        if self.questionNumber == 3 {

            refAnswer.child("Answer Three").observe(.value, with: { snapshot in
                
                    self.questionThrees.removeAll()
                    if let questionThree = QuestionThree(snapshot: snapshot) {
                        self.questionThrees.append(questionThree)
                    }
                
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 140
                self.tableView.reloadData()
                self.tableView.animateViews(animations: self.animations, delay: 0.3)
                print("is1\(self.questionOnes.count)")
                print("is2\(self.questionTwos.count)")
                print("is3\(self.questionThrees.count)")
                
            })
            
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]

        navigationItem.title = business.username
        
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));

    }
        
    func questionText() -> String {
        ///do some if stuff...
        if questionNumber == 1 {
            return business.questionOne!
        }
        if questionNumber == 2 {
            return business.questionTwo!
        } else {
            return business.questionThree!
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
