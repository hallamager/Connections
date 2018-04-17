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
    
    @IBOutlet weak var createButton: UIButtonStyles!
    @IBOutlet weak var profileImgEntered: UIImageView!
    @IBOutlet weak var detailsEntered: UIImageView!
    @IBOutlet weak var questionsEntered: UIImageView!
    @IBOutlet weak var cultureEntered: UIImageView!
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    let geoRefStudent = GeoFire(firebaseRef: Database.database().reference().child("student_locations"))
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("check database...")
        
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Industry") && snapshot.hasChild("Website") && snapshot.hasChild("profileImageURL") && snapshot.hasChild("Description") && snapshot.hasChild("Company Size") && snapshot.hasChild("Headquarters") && snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three") && snapshot.hasChild("CultureOne") && snapshot.hasChild("cultureTwo") && snapshot.hasChild("cultureThree"){
                
                self.createButton.isEnabled = true
                
                print("All info entered")
                
            } else {
                
                self.createButton.isEnabled = false
                
                print("Missing info")
            }
            
            if snapshot.hasChild("profileImageURL") {
                self.profileImgEntered.image = #imageLiteral(resourceName: "Ok")
                print("Image entered")
            }
            
            if snapshot.hasChild("Industry") && snapshot.hasChild("Website") && snapshot.hasChild("Description") && snapshot.hasChild("Headquarters") && snapshot.hasChild("Company Size"){
                
                self.detailsEntered.image = #imageLiteral(resourceName: "Ok")
                print("Details entered")
                
            }
            
            if snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three"){
                
                self.questionsEntered.image = #imageLiteral(resourceName: "Ok")
                print("Questions entered")
                
            }
            
            if snapshot.hasChild("CultureOne") && snapshot.hasChild("cultureTwo") && snapshot.hasChild("cultureThree"){
                
                self.cultureEntered.image = #imageLiteral(resourceName: "Ok")
                print("Culture entered")
                
            }
            
        })
        
    }
    
    func presentBusinessSwipeViewViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "StudentSWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
    }
    
    @IBAction func confirmProfileBtn(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        presentBusinessSwipeViewViewController()
        
        addToken()
        
    }
    
    func addToken() {
        
        let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid).child("FCM Token")
        
        // [START log_fcm_reg_token]
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // [END log_fcm_reg_token]
        
        ref.updateChildValues([token!: true])
        
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
