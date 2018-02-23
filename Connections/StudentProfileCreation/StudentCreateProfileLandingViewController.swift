//
//  StudentCreateProfileLandingViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GeoFire

class StudentCreateProfileLandingViewController: UIViewController {
    
    let geoRefStudent = GeoFire(firebaseRef: Database.database().reference().child("student_locations"))
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentBusinessSwipeViewViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
    }
    
    @IBAction func createProfileBtn(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}


extension StudentCreateProfileLandingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        let query = geoRefBusiness.query(at: location, withRadius: 1)
        query.observe(.keyEntered) { string, location in
            print(string)
        }
        
        geoRefStudent.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
        
    }
    
}
