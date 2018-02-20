//
//  BusinessRegisterViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 31/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Firebase
import GeoFire

class BusinessRegisterViewController: UIViewController, UITextFieldDelegate {
    
    let geoRef = GeoFire(firebaseRef: Database.database().reference().child("user_locations"))
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        companyNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        UIApplication.shared.statusBarStyle = .lightContent
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    //    }
    
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
                    ref.child("business").child(user!.uid).updateChildValues(["Company Name": self.companyNameTextField.text!, "type": "business"])
                    
                    ref.child("users").child(user!.uid).setValue(["type": "business"])

                    self.presentBusinessProfileCreationViewController()
                    
                    guard let userLocation = self.userLocation else { return }
                    
                    let data: [String: Any] = [
                        "lat": userLocation.coordinate.latitude,
                        "lng": userLocation.coordinate.longitude
                    ]
                    
                    ref.child("business").child(user!.uid).updateChildValues(data)

                }
                
            })
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentBusinessProfileCreationViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let BusinessCreateProfileLandingViewController:BusinessCreateProfileLandingViewController = storyboard.instantiateViewController(withIdentifier: "BusinessCreateProfileLandingViewController") as! BusinessCreateProfileLandingViewController
        self.present(BusinessCreateProfileLandingViewController, animated: true, completion: nil)
    }
    
}

extension StudentRegisterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        geoRef.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
        userLocation = location
        
    }
    
}
