//
//  Location.swift
//  Connections
//
//  Created by Hallam John Ager on 20/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation


class Location {
    
    var coordinate: CLLocationCoordinate2D!
    
    init(snapshot: DataSnapshot) {
        
        let data = snapshot.value as! [String: Any]
                
        coordinate = CLLocationCoordinate2D(
            latitude: data["Lat"] as! Double,
            longitude: data["Lng"] as! Double
        )
    }
    
}
