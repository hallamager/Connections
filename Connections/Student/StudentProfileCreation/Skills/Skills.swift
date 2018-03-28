//
//  Skills.swift
//  Connections
//
//  Created by Hallam John Ager on 25/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Skills {
    
    var uuid: String?
    let skill: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            skill = snapshotData["Skill"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        skill = data["Skill"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Skill": skill]
    }
    
}
