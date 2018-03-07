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
        
        let query = geoRefBusiness.query(at: location, withRadius: 20)
        
        guard location.distance(from: queryLocation) > 10 else { return }
        
        queryLocation = location
        query.observe(.keyEntered) { key, location in
            
            //            guard ["5w5tjm61ieMyT27ZeK3slp9U20U2"].contains(key) else { return }
            
            self.userViewed.observeSingleEvent(of: .value, with: { snapshot in
                
                let business = Business(snapshot: snapshot)
                business?.uuid = key
                guard [key].contains(key) else { return }
                
            })
            
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
    
//    func removefarawayBusinesses(for location: CLLocation) {
//
//        let query = geoRefBusiness.query(at: location, withRadius: 20)
//
//        guard location.distance(from: queryLocation) > 10 else { return }
//
//        queryLocation = location
//        query.observe(.keyExited) { key, location in
//
//            self.ref.child(key).observeSingleEvent(of: .value, with: { snapshot in
//
//                let business = Business(snapshot: snapshot)
//                business?.uuid = key
//                self.businesses.append(business!)
//                self.kolodaView.reloadData()
//                print(business!.username)
//
//            })
//
//        }
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoRefStudent.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
        loadNearbyBusinesses(for: location)
//        removefarawayBusinesses(for: location)
    }
    
    
}
