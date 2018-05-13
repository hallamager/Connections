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
    @IBOutlet weak var validationAlert: UILabel!
    
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
    
    func presentBusinessSwipeViewViewController() {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func createProfileBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("Address") && snapshot.hasChild("Headline") && snapshot.hasChild("profileImageURL") && snapshot.hasChild("Summary") && snapshot.hasChild("Interest One") && snapshot.hasChild("Interest Two") && snapshot.hasChild("Interest Three"){
                
                self.createButton.isEnabled = true
                
                self.presentBusinessSwipeViewViewController()
                
                self.locationManager.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                
                self.addToken()
                
                self.addSelectedRadius()
                
                print("All info entered")
                
            } else {
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x - 10, y: self.validationAlert.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.validationAlert.center.x + 10, y: self.validationAlert.center.y))
                
                self.validationAlert.layer.add(animation, forKey: "position")
                
                self.createButton.isEnabled = false
                self.validationAlert.text = "Not all sections have been completed."
                
                print("Missing info")
                
                return
            }
            
        })
        
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
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        geoRefStudent.setLocation(location, forKey: uid)
        
    }
    
}
