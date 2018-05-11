//
//  QuestionTwo.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 19/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class QuestionTwo {
    
    var uuid: String?
    let questionTwo: String?
    let status: String?
    let liked: String?
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            questionTwo = snapshotData["Question Two Answer"] as? String
            status = snapshotData["Status"] as? String
            liked = snapshotData["Liked"] as? String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        questionTwo = data["Question Two Answer"] as? String
        status = data["Status"] as? String
        liked = data["Liked"] as? String
    }

    
    func toDict2() -> [String: Any] {
        return ["Question Two Answer": questionTwo!, "Status": "Sent"]
    }

    
}
