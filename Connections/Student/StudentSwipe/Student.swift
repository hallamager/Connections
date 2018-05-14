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
    let address: String?
    let summary: String?
    let headline: String?
    let profileImageURL: String?
    let interestOne: String?
    let interestTwo: String?
    let interestThree: String?
    let selectedRadius: Int?
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            username = snapshotData["Username"] as! String
            address = snapshotData["Address"] as? String
            headline = snapshotData["Headline"] as? String
            summary = snapshotData["Summary"] as? String
            profileImageURL = snapshotData["profileImageURL"] as? String
            interestOne = snapshotData["Interest One"] as? String
            interestTwo = snapshotData["Interest Two"] as? String
            interestThree = snapshotData["Interest Three"] as? String
            selectedRadius = (snapshotData["Selected Radius"] as? NSString)?.integerValue
        } else {
            return nil
        }
        
    }
    
}
