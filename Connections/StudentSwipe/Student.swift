//
//  Student.swift
//  Connections
//
//  Created by Hallam John Ager on 02/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Firebase

class Student {
    
    let uuid: String
    let username: String
    let industry: String
    let description: String
    let profileImageURL: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            username = snapshotData["Username"] as! String
            industry = snapshotData["Industry"] as! String
            description = snapshotData["Description"] as! String
            profileImageURL = snapshotData["profileImageURL"] as! String
        } else {
            return nil
        }
        
    }
    
    
}
