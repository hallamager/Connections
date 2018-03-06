//
//  ViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 13/10/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import UIKit
import Koloda
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class BusinessSwipeViewController: UIViewController, CLLocationManagerDelegate, StudentEditProfileViewControllerDelegate {
    
    func sliderChanged(text: String?) {
        print(text!)
    }
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var OpenMenuLeft: UIBarButtonItem!
    
    
    let refLikes = Database.database().reference()
    let ref = Database.database().reference().child("business")
    var businesses = [Business]()
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    let locationManager = CLLocationManager()
    
    var queryLocation = CLLocation(latitude: 0, longitude: 0)
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //open menu with tab bar button
        OpenMenuLeft.target = self.revealViewController()
        OpenMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func loadNearbyBusinesses(for location: CLLocation) {
        
        let query = geoRefBusiness.query(at: location, withRadius: 20)
        
        guard location.distance(from: queryLocation) > 5 else { return }
        
        queryLocation = location
        query.observe(.keyEntered) { key, location in
            
            guard ["5w5tjm61ieMyT27ZeK3slp9U20U2"].contains(key) else { return }
            
            self.ref.child(key).observeSingleEvent(of: .value, with: { snapshot in

                let business = Business(snapshot: snapshot)
                business?.uuid = key
                self.businesses.append(business!)
                print(business!.username)
                self.kolodaView.reloadData()

            })

        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        loadNearbyBusinesses(for: location)
    }
    
    
    func addLiked(_ business: Business) {
        
        let moreLikes = refLikes.child("studentsLiked/\(Auth.auth().currentUser!.uid)")
        let newLike = refLikes.child("businessesLiked/").child(business.uuid)
        let dict = [
            Auth.auth().currentUser!.uid: true,
        ]
        let business = [
            business.uuid: true,
        ]
        
        newLike.updateChildValues(dict)
        moreLikes.updateChildValues(business)
        
        self.counter += 1
        
    }
    
    func addDisliked(_ business: Business) {
        
        let newDislike = refLikes.child("businessesDisliked/").child(business.uuid)
        let dict = [
            Auth.auth().currentUser!.uid: true,
            ]
        
        newDislike.updateChildValues(dict)
        
        self.counter += 1
        
    }
    
    func userViewed(_ business: Business) {
        
        let newView = refLikes.child("userViewed/\(Auth.auth().currentUser!.uid)")
        
        let business = [
            business.uuid: true,
        ]
        
        newView.updateChildValues(business)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let business = businesses[counter]
        let vc = segue.destination as! BusinessMoreInfoViewController
        vc.business = business
    }
    
    
}

extension BusinessSwipeViewController: KolodaViewDelegate {
    
    //what happens when user runs out of cards
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("Out of cards")
    }
    
    //what happens when card is pressed
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: "MoreInfo", sender: nil)
    }
    
    // point at wich card disappears
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.1
    }
    
    
    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        // If you return false the card will not move.
        return true
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        let business = businesses[index]
        
        if direction == SwipeResultDirection.right {
            
            addLiked(self.businesses[counter])
            userViewed(self.businesses[counter])
            
        } else if direction == .left {
            
            addDisliked(self.businesses[counter])
            userViewed(self.businesses[counter])
            
        }
        
        print("did swipe \(business) in direction: \(direction)")
        
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        //        print("being swiped \(direction)")
        
//        if direction == SwipeResultDirection.right {
//            // implement your functions or whatever here
//            print("user swiping right")
//            
//            
//        } else if direction == .left {
//            // implement your functions or whatever here
//            print("user swiping left")
//        }
        
    }
    
}

extension BusinessSwipeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return businesses.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let BusinessSwipeView = Bundle.main.loadNibNamed("BusinessSwipeView", owner: self, options: nil)![0] as! BusinessSwipeView
        
        let business = businesses[index]
        
        BusinessSwipeView.businessName.text = business.username
        BusinessSwipeView.businessIndustry.text = business.industry
        BusinessSwipeView.businessHeadquarters.text = business.businessHeadquarters
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            BusinessSwipeView.profilePic.image = pic
        }
        
        return BusinessSwipeView
        
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
}
