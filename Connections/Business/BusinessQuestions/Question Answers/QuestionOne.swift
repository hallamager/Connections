//
//  QuestionOne.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 16/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class QuestionOne {
    
    var uuid: String?
    let questionOne: String?
    let status: String?
    let liked: String?
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            questionOne = snapshotData["Question One Answer"] as? String
            status = snapshotData["Status"] as? String
            liked = snapshotData["Liked"] as? String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        questionOne = data["Question One Answer"] as? String
        status = data["Status"] as? String
        liked = data["Liked"] as? String
    }
    
    func toDict1() -> [String: Any] {
        return ["Question One Answer": questionOne!, "Status": "Sent"]
    }
    
}
