//
//  Messages.swift
//  Connections
//
//  Created by Hallam John Ager on 13/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import UIKit
import Firebase

class Messages: NSObject {

    var sentToUser: String
    var sentFromUser: String
    var timeStamp: NSNumber
    var text: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            sentToUser = snapshotData["sentToUser"] as! String
            sentFromUser = snapshotData["sentFromUser"] as! String
            timeStamp = snapshotData["timeStamp"] as! NSNumber
            text = snapshotData["text"] as! String
        } else {
            return nil
        }
    }
    
}
