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
    @IBOutlet weak var questionTitle: UILabel!
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        
        guard let textField = textField.text, !textField.isEmpty else {
            return
        }
        
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

        self.textField.text! = ""
        self.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child("business").child(business.uuid)
        
        ref.observe(.value, with: { snapshot in
            if let business = Business(snapshot: snapshot) {
                self.businesses.append(business)
                self.tableView.reloadData()
                print("business \(self.businesses.count)")
            }
        })
        
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
        
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));

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
                
                cell.answer.translatesAutoresizingMaskIntoConstraints = true
                cell.answer.sizeToFit()
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
                
                cell.answer.translatesAutoresizingMaskIntoConstraints = true
                cell.answer.sizeToFit()
                cell.answer.isScrollEnabled = false
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
                
                cell.answer.translatesAutoresizingMaskIntoConstraints = true
                cell.answer.sizeToFit()
                cell.answer.isScrollEnabled = false
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
            return cell
        }
    
        return cell
        
    }

}

