//
//  ChatInvite.swift
//  Connections
//
//  Created by Hallam John Ager on 28/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Invites {
    
    var uuid: String?
    let date: String
    let time: String
    let inviteType: String
    let response: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            date = snapshotData["Date"] as! String
            time = snapshotData["Time"] as! String
            inviteType = snapshotData["Invite Type"] as! String
            response = snapshotData["Response"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        date = data["Date"] as! String
        time = data["Time"] as! String
        inviteType = data["Invite Type"] as! String
        response = data["Response"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Date": date, "Time": time, "Invite Type": inviteType, "Response": response]
    }
    
}
