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

class ViewStudentResponses: UIViewController {
    
    var businesses = [Business]()
    var student: Student!
    var questionNumber: Int!
    var studentResponses = [StudentResponses]()
    var studentResponse: StudentResponses!
    
    let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)")
    
    @IBOutlet var businessQuestion: UILabel!
    @IBOutlet var studentAnswer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = student.username
        
        let refAnswer = Database.database().reference().child("studentResponses/\(Auth.auth().currentUser!.uid)").child(student.uuid)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let business = Business(snapshot: snapshot) {
                if self.questionNumber == 1 {
                    self.businessQuestion.text = business.questionOne
                    self.businesses.append(business)
                }
                if self.questionNumber == 2 {
                    self.businessQuestion.text = business.questionTwo
                    self.businesses.append(business)
                }
                if self.questionNumber == 3 {
                    self.businessQuestion.text = business.questionThree
                    self.businesses.append(business)
                }
                
            }
        })
        
        refAnswer.observeSingleEvent(of: .value, with: { snapshot in
            if let business = StudentResponses(snapshot: snapshot) {
                if self.questionNumber == 1 {
                    self.studentResponses.append(business)
                    self.studentAnswer.text = business.questionOne
                }
                if self.questionNumber == 2 {
                    self.studentResponses.append(business)
                    self.studentAnswer.text = business.questionTwo
                }
                if self.questionNumber == 3 {
                    self.studentResponses.append(business)
                    self.studentAnswer.text = business.questionThree
                }
                
            }
        })
        
    }
    
}
