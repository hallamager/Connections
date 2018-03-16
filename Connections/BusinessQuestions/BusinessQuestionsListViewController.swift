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
    
    @IBOutlet var questionOne: UITextView!
    @IBOutlet var textField: UITextView!
    @IBAction func nextQuestionButton(_ sender: Any) {
        ref.child(business.uuid).child(Auth.auth().currentUser!.uid).updateChildValues(["Question One Answer": self.textField.text!])
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)!]

        
        navigationItem.title = business.username
        
        questionOne.text = business.questionOne
        
    }
    
}
