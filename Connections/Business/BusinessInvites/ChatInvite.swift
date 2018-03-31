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
    let date2: String
    let time2: String
    let inviteType: String
    let response: String
    let responseFirstDate: String
    let responseSecondDate: String
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            date = snapshotData["Date1"] as! String
            time = snapshotData["Time1"] as! String
            date2 = snapshotData["Date2"] as! String
            time2 = snapshotData["Time2"] as! String
            inviteType = snapshotData["Invite Type"] as! String
            response = snapshotData["Response"] as! String
            responseFirstDate = snapshotData["First Date Response"] as! String
            responseSecondDate = snapshotData["Second Date Response"] as! String
        } else {
            return nil
        }
        
    }
    
    init(data: [String: Any]) {
        date = data["Date1"] as! String
        time = data["Time1"] as! String
        date2 = data["Date2"] as! String
        time2 = data["Time2"] as! String
        inviteType = data["Invite Type"] as! String
        response = data["Response"] as! String
        responseFirstDate = data["First Date Response"] as! String
        responseSecondDate = data["Second Date Response"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["Date1": date, "Time1": time, "Date2": date2, "Time2": time2, "Invite Type": inviteType, "Response": response, "First Date Response": responseFirstDate, "Second Date Response": responseSecondDate]
    }
    
}
