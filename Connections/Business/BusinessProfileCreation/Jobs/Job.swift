//
//  Jobs.swift
//  Connections
//
//  Created by Hallam John Ager on 02/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Job {
    
    var uuid: String?
    let title: String
    let description: String
    let employmentType: String
//    let salary: String
//    let skillsRequired: String
//    let location: String
    
    //traits+skills
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            title = snapshotData["Title"] as! String
            employmentType = snapshotData["Employment Type"] as! String
            description = snapshotData["Description"] as! String
//            salary = snapshotData["Salary"] as! String
//            skillsRequired = snapshotData["Skills Required"] as! String
//            location = snapshotData["Location"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        title = data["Title"] as! String
        employmentType = data["Employment Type"] as! String
        description = data["Description"] as! String
//        salary = data["Salary"] as! String
//        skillsRequired = data["Skills Required"] as! String
//        location = data["Location"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Title": title, "Employment Type": employmentType, "Description": description]
    }
    
}
