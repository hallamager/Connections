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

        loadRelatedResponses(for: Auth.auth().currentUser!.uid) { success, questionOnes in
            self.questionOnes = questionOnes
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
        }
        
        navigationItem.title = business.username
        
        questionOne.text = business.questionOne
        
    }
    
    func loadRelatedResponses(for BusinessUID: String, completion: @escaping (Bool, [QuestionOne]) -> ()) {
        
        let ref = Database.database().reference().child(business.uuid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            self.questionOnes.removeAll()

            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "studentResponses").child(self.business.uuid).child(Auth.auth().currentUser!.uid)
            var questionOnes = [QuestionOne]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let questionOne = QuestionOne(snapshot: snapshot)
                        questionOnes.append(questionOne!)
                        count += 1
                        if count == uids.count {
                            completion(true, questionOnes)
                        }
                    }
                }
            } else {
                completion(true, questionOnes)
            }
        }
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254
    }
    
}

extension BusinessQuestionsListViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(questionOnes.count)
        return questionOnes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionOne") as! ShowQuestionOne
        let questionOne = questionOnes[indexPath.row]
        cell.questionOne?.text = questionOne.questionOne
        return cell
    }
    
}
