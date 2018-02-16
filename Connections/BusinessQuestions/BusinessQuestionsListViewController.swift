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

class BusinessQuestionsListViewController: UIViewController {
    
    var business: Business!
    let ref = Database.database().reference().child("studentResponses")
    
    @IBOutlet var questionOne: UILabel!
    @IBOutlet var textField: UITextField!
    @IBAction func nextQuestionButton(_ sender: Any) {
        ref.child(business.uuid).child(Auth.auth().currentUser!.uid).updateChildValues([business.questionOne: self.textField.text!])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = business.username
        
        questionOne.text = business.questionOne
        
    }
    
}
