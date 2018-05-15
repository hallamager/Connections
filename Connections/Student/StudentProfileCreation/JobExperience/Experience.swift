//
//  Experience.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Experience {
    
    var uuid: String?
    let title: String
    let company: String
    let fromDate: String
    let toDate: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            title = snapshotData["Title"] as! String
            company = snapshotData["Company"] as! String
            fromDate = snapshotData["From Date"] as! String
            toDate = snapshotData["To Date"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        title = data["Title"] as! String
        company = data["Company"] as! String
        fromDate = data["From Date"] as! String
        toDate = data["To Date"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Title": title, "Company": company, "From Date": fromDate, "To Date": toDate]
    }
    
}
