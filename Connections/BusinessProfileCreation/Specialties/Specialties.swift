//
//  Specialties.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Specialties {
    
    var uuid: String?
    let specialties: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            specialties = snapshotData["Specialties"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        specialties = data["Specialties"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Specialties": specialties]
    }
    
}
