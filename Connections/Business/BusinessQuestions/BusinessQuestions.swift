//
//  BusinessQuestions.swift
//  Connections
//
//  Created by Hallam John Ager on 16/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class BusinessQuestions {
    
    let uuid: String
    let questionOne: String
    let questionTwo: String
    let questionThree: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            questionOne = snapshotData["Question One"] as! String
            questionTwo = snapshotData["Question Two"] as! String
            questionThree = snapshotData["Question Three"] as! String
        } else {
            return nil
        }
    }
    
    
}
