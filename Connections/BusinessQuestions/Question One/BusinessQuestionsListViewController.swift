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
 
    let ref = Database.database().reference().child("studentResponses")
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionOne: UITextView!
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid)
//        ref.child(business.uuid).child(Auth.auth().currentUser!.uid).updateChildValues(["Question One Answer": self.textField.text!])
        let ex = QuestionOne(data: ["Question One Answer": self.textField.text!])
        refQuestion.updateChildValues(ex.toDict())
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]
        

        
        
        
        
        navigationItem.title = business.username
        
        questionOne.text = questionText()
        
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionOne") as! ShowQuestionOne
        
//        let questionOne = questionOnes[indexPath.row]
        cell.questionOne?.text = questionOne.questionOne

        cell.questionOne.translatesAutoresizingMaskIntoConstraints = true
        cell.questionOne.sizeToFit()
        cell.questionOne.isScrollEnabled = false
        cell.questionOne.layer.cornerRadius = 10.0
        
        return cell
    }
    
}
