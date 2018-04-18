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
    
    @IBOutlet weak var createButton: UIButtonStyles!
    @IBOutlet weak var profilePictureEntered: UIImageView!
    @IBOutlet weak var personalEntered: UIImageView!
    @IBOutlet weak var interestsEntered: UIImageView!
    
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
    let geoRefStudent = GeoFire(firebaseRef: Database.database().reference().child("student_locations"))
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    let locationManager = CLLocationManager()
    var appContainer: SWRevealViewController!
    var students = [Student]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("check database...")
        
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Address") && snapshot.hasChild("Headline") && snapshot.hasChild("profileImageURL") && snapshot.hasChild("Summary") && snapshot.hasChild("Interest One") && snapshot.hasChild("Interest Two") && snapshot.hasChild("Interest Three"){
                
                self.createButton.isEnabled = true
                
                print("All info entered")
                
            } else {
                
                self.createButton.isEnabled = false
                
                print("Missing info")
            }
            
            if snapshot.hasChild("profileImageURL") {
                self.profilePictureEntered.image = #imageLiteral(resourceName: "Ok")
                print("Image entered")
            }
            
            if snapshot.hasChild("Address") && snapshot.hasChild("Headline") && snapshot.hasChild("Summary"){
                
                self.personalEntered.image = #imageLiteral(resourceName: "Ok")
                print("Details entered")
                
            }
            
            if snapshot.hasChild("Interest One") && snapshot.hasChild("Interest Two") && snapshot.hasChild("Interest Three"){
                
                self.interestsEntered.image = #imageLiteral(resourceName: "Ok")
                print("Questions entered")
                
            }
            
        })
        
    }
    
    func presentBusinessSwipeViewViewController() {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func createProfileBtn(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        addToken()
        
        addSelectedRadius()
        
        presentBusinessSwipeViewViewController()
        
    }
    
    func addToken() {
    
        let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid).child("FCM Token")

        // [START log_fcm_reg_token]
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // [END log_fcm_reg_token]

        ref.updateChildValues([token!: true])
    
    }
    
    func addSelectedRadius() {
        
        let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
        
        ref.updateChildValues(["Selected Radius": "40"])
        
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
