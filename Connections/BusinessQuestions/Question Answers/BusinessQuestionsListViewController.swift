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

class BusinessQuestionsListViewController: UIViewController {
    
    var business: Business!
    var questionNumber: Int!
    var questionOnes = [QuestionOne]()
    var questionTwos = [QuestionTwo]()
    var questionThrees = [QuestionThree]()
 
    let ref = Database.database().reference().child("studentResponses")
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionOne: UITextView!
    @IBOutlet weak var questionTitle: UILabel!
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        
        if questionNumber == 1 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid)
            let ex = QuestionOne(data: ["Question One Answer": self.textField.text!])
            refQuestion.updateChildValues(ex.toDict1())
        }
        
        if questionNumber == 2 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid)
            let ex = QuestionTwo(data: ["Question Two Answer": self.textField.text!])
            refQuestion.updateChildValues(ex.toDict2())
        }
        
        if questionNumber == 3 {
            let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid)
            let ex = QuestionThree(data: ["Question Three Answer": self.textField.text!])
            refQuestion.updateChildValues(ex.toDict3())
        }

        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if questionNumber == 1 {
            questionTitle.text = "Question One"
        }
        
        if questionNumber == 2 {
            questionTitle.text = "Question Two"
        }
        
        if questionNumber == 3 {
            questionTitle.text = "Question Three"
        }
        
        let refAnswer = Database.database().reference().child("studentResponses/\(business.uuid)").child(Auth.auth().currentUser!.uid)
        
        refAnswer.observe(.value, with: { snapshot in
            
            if self.questionNumber == 1 {
                self.questionOnes.removeAll()
            }
            
            if self.questionNumber == 2 {
                self.questionTwos.removeAll()
            }
            
            if self.questionNumber == 3 {
                self.questionThrees.removeAll()
            }
            
            if self.questionNumber == 1 {
                if let questionOne = QuestionOne(snapshot: snapshot) {
                    self.questionOnes.append(questionOne)
                }
            }
            
            if self.questionNumber == 2 {
                if let questionTwo = QuestionTwo(snapshot: snapshot) {
                    self.questionTwos.append(questionTwo)
                }
            }
            
            if self.questionNumber == 3 {
                if let questionThree = QuestionThree(snapshot: snapshot) {
                    self.questionThrees.append(questionThree)
                }
            }
            
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            print("is\(self.questionOnes.count)")
            print("is\(self.questionTwos.count)")
            print("is\(self.questionThrees.count)")
        })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]

        navigationItem.title = business.username
        
//        questionOne.text = questionText()
        
    }
    
    func questionText() -> String {
        ///do some if stuff...
        if questionNumber == 1 {
            return business.questionOne
        }
        
        if questionNumber == 2 {
            return business.questionTwo
        } else {
            return business.questionThree
        }
        
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

extension BusinessQuestionsListViewController: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        if questionNumber == 1 {
            return questionOnes.count
        }
        
        if questionNumber == 2 {
            return questionTwos.count
        } else {
            return questionThrees.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionOne") as! ShowQuestionOne

        if questionNumber == 1 {
            let questionOne = questionOnes[indexPath.row]
            cell.questionOne?.text = questionOne.questionOne
            return cell
        }
        
        if questionNumber == 2 {
            let questionTwo = questionTwos[indexPath.row]
            cell.questionOne?.text = questionTwo.questionTwo
            return cell
        } else {
            let questionThree = questionThrees[indexPath.row]
            cell.questionOne?.text = questionThree.questionThree
            return cell
        }
//
//        cell.questionOne.translatesAutoresizingMaskIntoConstraints = true
//        cell.questionOne.sizeToFit()
//        cell.questionOne.isScrollEnabled = false
//        cell.questionOne.layer.cornerRadius = 10.0

    }

}

