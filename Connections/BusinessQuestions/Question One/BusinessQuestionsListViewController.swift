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
    var questionOnes = [QuestionOne]()
    let ref = Database.database().reference().child("studentResponses")
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    @IBOutlet var questionOne: UITextView!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        let refQuestion = Database.database().reference().child("studentResponses").child(business.uuid).child(Auth.auth().currentUser!.uid)
//        ref.child(business.uuid).child(Auth.auth().currentUser!.uid).updateChildValues(["Question One Answer": self.textField.text!])
        let ex = QuestionOne(data: ["Question One Answer": self.textField.text!])
        refQuestion.updateChildValues(ex.toDict())
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]
        
        let refAnswer = Database.database().reference().child("studentResponses/\(business.uuid)").child(Auth.auth().currentUser!.uid)
        
//        refAnswer.observeSingleEvent(of: .value, with: { snapshot in
//            self.questionOnes.removeAll()
//            if let business = QuestionOne(snapshot: snapshot) {
//                self.questionOnes.append(business)
//            }
//            self.tableView.reloadData()
//            self.tableView.animateViews(animations: self.animations, delay: 0.3)
//        })
        
        refAnswer.observe(.value, with: { snapshot in
            self.questionOnes.removeAll()

            if let questionOne = QuestionOne(snapshot: snapshot) {
                self.questionOnes.append(questionOne)
            }

            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
            print("is\(self.questionOnes.count)")
        })
        
        navigationItem.title = business.username
        
        questionOne.text = business.questionOne
        
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print("count \(questionOnes.count)")
        return questionOnes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionOne") as! ShowQuestionOne
        let questionOne = questionOnes[indexPath.row]
        cell.questionOne?.text = questionOne.questionOne
        return cell
    }
    
}
