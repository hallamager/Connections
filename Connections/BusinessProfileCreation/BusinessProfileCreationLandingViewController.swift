//
//  BusinessProfileCreationLandingViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 02/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GeoFire

class BusinessCreateProfileLandingViewController: UIViewController {
    
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    let geoRefStudent = GeoFire(firebaseRef: Database.database().reference().child("student_locations"))
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func presentBusinessSwipeViewViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
    }
    
    @IBAction func confirmProfileBtn(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
}

extension BusinessCreateProfileLandingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        let query = geoRefStudent.query(at: location, withRadius: 1)
        query.observe(.keyEntered) { string, location in
            print(string)
        }
        geoRefBusiness.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
        userLocation = location
        
    }
    
}
