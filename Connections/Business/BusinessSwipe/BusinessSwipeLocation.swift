//
//  BusinessSwipeLocation.swift
//  Connections
//
//  Created by Hallam John Ager on 07/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GeoFire

extension BusinessSwipeViewController {
        
    func loadNearbyBusinesses(for location: CLLocation) {
        
        let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                
                let query = self.geoRefBusiness.query(at: location, withRadius: Double(student.selectedRadius!))
                
                guard location.distance(from: self.queryLocation) > 50 else { return }
                
                self.queryLocation = location
                query.observe(.keyEntered) { key, location in
                    
                    guard !ViewedManager.shared.uuids.contains(key) else { return }
                    
                    self.businesses.removeAll()
                    
                    self.ref.child(key).observeSingleEvent(of: .value, with: { snapshot in
                        
                        let business = Business(snapshot: snapshot)
                        business?.uuid = key
                        self.businesses.append(business!)
                        print(business!.username)
                        self.kolodaView.reloadData()
                        
                    })
                    
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, let uid = Auth.auth().currentUser?.uid else { return }
        geoRefStudent.setLocation(location, forKey: uid)
        loadNearbyBusinesses(for: location)
        
    }
    
}
