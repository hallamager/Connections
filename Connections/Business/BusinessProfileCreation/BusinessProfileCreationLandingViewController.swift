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
    @IBOutlet weak var validationAlert: UILabel!
    
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    let refValidUser = Database.database().reference().child("validBusinesses")
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
    
    func presentBusinessSwipeViewViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
        let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "StudentSWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
    }
    
    @IBAction func confirmProfileBtn(_ sender: UIButton) {
        
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
            
            if snapshot.hasChild("Industry") && snapshot.hasChild("Website") && snapshot.hasChild("profileImageURL") && snapshot.hasChild("Description") && snapshot.hasChild("Company Size") && snapshot.hasChild("Headquarters") && snapshot.hasChild("Question One") && snapshot.hasChild("Question Two") && snapshot.hasChild("Question Three") && snapshot.hasChild("cultureOne") && snapshot.hasChild("cultureTwo") && snapshot.hasChild("cultureThree"){
                
                self.createButton.isEnabled = true
                
                let rootRef = Database.database().reference(fromURL: "https://connections-bd790.firebaseio.com/")
                let businessRef = rootRef.child("business").child(Auth.auth().currentUser!.uid)
                
                //get each child node of businessRef
                businessRef.observe(.value, with: { snapshot in
                    
                    //set up a  node and write the snapshot.value to it
                    // using the key as the node name and the value as the value.
                    let validNode = rootRef.child("business").child("valid")
                    let thisValidNode = validNode.child(snapshot.key)
                    thisValidNode.setValue(snapshot.value) //write to the new node
                    
                    //get a reference to the data we just read and remove it
                    let nodeToRemove = businessRef.child(snapshot.key)
                    nodeToRemove.removeValue();
                    
                })
                
                self.locationManager.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                
                self.presentBusinessSwipeViewViewController()
                
                self.addToken()
                
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
            }
            
        })
        
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
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        geoRefBusiness.setLocation(location, forKey: uid)
        userLocation = location
        
    }
    
}
