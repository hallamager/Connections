//
//  Education.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Education {
    
    var uuid: String?
    let school: String
    let qType: String
    let studied: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            school = snapshotData["School"] as! String
            qType = snapshotData["Qualification Type"] as! String
            studied = snapshotData["Studied"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        school = data["School"] as! String
        qType = data["Qualification Type"] as! String
        studied = data["Studied"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["School": school, "Qualification Type": qType, "Studied": studied]
    }
    
}
