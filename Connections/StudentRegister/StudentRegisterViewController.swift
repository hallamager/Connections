//
//  StudentRegisterViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import GeoFire

class StudentRegisterViewController: UIViewController, UITextFieldDelegate {
    
    let geoRef = GeoFire(firebaseRef: Database.database().reference().child("user_locations"))
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        // checking if the fields are not nil
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            let ref = Database.database().reference()
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if let firebaseError = error {
                    
                    print(firebaseError.localizedDescription)
                    return
                    
                } else {
                    
                    // following method is a add user's more details
                    ref.child("student").child(user!.uid).updateChildValues(["Username": self.usernameTextField.text!, "type": "student"])
                    
                    ref.child("users").child(user!.uid).setValue(["type": "student"])
                    
                    guard let userLocation = self.userLocation else { return }
                    
                    let data: [String: Any] = [
                        "lat": userLocation.coordinate.latitude,
                        "lng": userLocation.coordinate.longitude
                    ]
                    
                    ref.child("student").child(user!.uid).updateChildValues(data)
                    
                }
                
            })
            
            self.presentStudentProfileCreationViewController()
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentStudentProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StudentCreateProfileLandingViewController:StudentCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "StudentCreateProfileLandingViewController") as! StudentCreateProfileLandingViewController
        self.present(StudentCreateProfileLandingViewController, animated: true, completion: nil)
    }
    

}

extension StudentRegisterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        geoRef.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
        userLocation = location
        
    }
    
}
