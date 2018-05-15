//
//  BusinessMatchedCell.swift
//  Connections
//
//  Created by Hallam John Ager on 10/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseStorage
import ViewAnimator

extension BusinessLikedViewController  {
    
    func loadMatches(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
        
        let ref = Database.database().reference(withPath: "matches/" + Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "business").child("valid")
            var matchedBusinesses = [Business]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let business = Business(snapshot: snapshot)
                        matchedBusinesses.append(business!)
                        count += 1
                        if count == uids.count {
                            completion(true, matchedBusinesses)
                        }
                    }
                }
            } else {
                completion(true, matchedBusinesses)
            }
        }
    }
    
}

