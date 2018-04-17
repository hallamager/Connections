//
//  Business.swift
//  Connections
//
//  Created by Hallam John Ager on 02/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

class Business {
    
    var uuid: String
    let username: String
    let industry: String
    let description: String
    let questionOne: String
    let questionTwo: String
    let questionThree: String
    let profileImageURL: String
    let businessHeadquarters: String
    let companyWebsite: String
    let companySize: String
    let cultureOne: String
    let cultureTwo: String
    let cultureThree: String
    var jobs = [Job]()
    
    var numberOfJobs: Int {
        return jobs.count
    }
    
    var hasJobs: Bool {
        return jobs.count > 0
    }
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            username = snapshotData["Company Name"] as! String
            industry = snapshotData["Industry"] as! String
            description = snapshotData["Description"] as! String
            questionOne = snapshotData["Question One"] as! String
            questionTwo = snapshotData["Question Two"] as! String
            questionThree = snapshotData["Question Three"] as! String
            profileImageURL = snapshotData["profileImageURL"] as! String
            businessHeadquarters = snapshotData["Headquarters"] as! String
            companyWebsite = snapshotData["Website"] as! String
            companySize = snapshotData["Company Size"] as! String
            cultureOne = snapshotData["CultureOne"] as! String
            cultureTwo = snapshotData["cultureTwo"] as! String
            cultureThree = snapshotData["cultureThree"] as! String
            
            buildJobs(snapshot: snapshot.childSnapshot(forPath: "Jobs"))
                    
        } else {
            return nil
        }
    }
    
    private func buildJobs(snapshot: DataSnapshot) {
        for jobSnap in snapshot.children {
            if let job = Job(snapshot: jobSnap as! DataSnapshot) {
                self.jobs.append(job)
            }
        }
    }
    
    
}


