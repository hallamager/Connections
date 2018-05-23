//
//  StudentSwipeViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 03/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Koloda
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class StudentSwipeViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var OpenMenuLeft: UIBarButtonItem!
    @IBOutlet weak var noCardsAlert: UILabel!
    @IBOutlet weak var openMoreInfo: UIButton!
    
    
    let refLikes = Database.database().reference()
    let ref = Database.database().reference().child("student").child("valid")
    var businesses = [Business]()
    var students = [Student]()
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        loadRelatedStudents(for: Auth.auth().currentUser!.uid) { success, students in
            self.students = students
            self.kolodaView.reloadData()
        }
        
        //open menu with tab bar button
        OpenMenuLeft.target = self.revealViewController()
        OpenMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoRefBusiness.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
    }
    
    func loadRelatedStudents(for businessUID: String, completion: @escaping (Bool, [Student]) -> ()) {
        
        let ref = Database.database().reference().child("businessesLiked").child(Auth.auth().currentUser!.uid)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "student").child("valid")
            var students = [Student]()
            var count = 0
            
            
            if uids.count != 0 {
                uids.forEach { uid in
                    
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        
                        let student = Student(snapshot: snapshot)
                        students.append(student!)
                        
                        count += 1
                        if count == uids.count {
                            completion(true, students)
                        }
                        
                    }
                }
            } else {
                completion(true, students)
            }
            
        }
        
    }
    
    func addLiked(_ student: Student) {
        
        
        let newLike = refLikes.child("matches").child(student.uuid)
        let dict = [
            Auth.auth().currentUser!.uid: true,
            ]
        
        newLike.updateChildValues(dict)
        
        let newBusinessLike = refLikes.child("matchesBusiness/\(Auth.auth().currentUser!.uid)")
        let newView = refLikes.child("userViewed/\(Auth.auth().currentUser!.uid)")
        
        let dictBusiness = [
            student.uuid: true,
            ]
        
        newBusinessLike.updateChildValues(dictBusiness)
        newView.updateChildValues(dictBusiness)
        
        self.counter += 1
        
        let refDeleteSeen = Database.database().reference().child("businessesLiked").child(Auth.auth().currentUser!.uid).child(student.uuid)
        
        refDeleteSeen.removeValue()
        
    }
    
    func addDisliked(_ student: Student) {
        
        let newLike = refLikes.child("studentsDisliked").child(student.uuid)
        let newView = refLikes.child("userViewed/\(Auth.auth().currentUser!.uid)")
        
        let dict = [
            Auth.auth().currentUser!.uid: true,
            ]
        
        let dictBusiness = [
            student.uuid: true,
            ]
        
        newLike.updateChildValues(dict)
        newView.updateChildValues(dictBusiness)
        
        let refDeleteSeen = Database.database().reference().child("businessesLiked").child(Auth.auth().currentUser!.uid).child(student.uuid)
        
        refDeleteSeen.removeValue()
        
        self.counter += 1
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let student = students[counter]
        let vc = segue.destination as! StudentMoreInfoViewController
        vc.student = student
    }
    
    @IBAction func moreInfoBtn(_ sender: UIButton) {
        
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
        
        performSegue(withIdentifier: "StudentMoreInfo", sender: nil)
    }
    
}

extension StudentSwipeViewController: KolodaViewDelegate {
    
    //what happens when user runs out of cards
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        openMoreInfo.isEnabled = false
        noCardsAlert.text = "Your Out of Cards! We'll alert when theres more to swipe."
        print("Out of cards")
    }
    
    //what happens when card is pressed
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: "StudentMoreInfo", sender: nil)
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
        
        let student = students[index]
        
        if direction == SwipeResultDirection.right {
            
            addLiked(self.students[counter])
            
        } else if direction == .left {
            
            addDisliked(self.students[counter])
            
        }
        
        print("did swipe \(student) in direction: \(direction)")
        
    }
    
}

extension StudentSwipeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        print(students.count)
        
        if students.count == 0 {
            noCardsAlert.text = "Your Out of Cards! We'll alert when theres more to swipe."
            openMoreInfo.isEnabled = false
        } else {
            noCardsAlert.text = ""
            openMoreInfo.isEnabled = true
        }
        
        return students.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let StudentSwipeView = Bundle.main.loadNibNamed("StudentSwipeView", owner: self, options: nil)![0] as! StudentSwipeView
        
        let student = students[index]
        
        StudentSwipeView.studentName.text = student.username
        StudentSwipeView.studentHeadline.text = student.headline
        StudentSwipeView.studentLocation.text = student.address
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(student.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            StudentSwipeView.studentProfileImg.image = pic
        }
        
        print(student.username)
        
        return StudentSwipeView
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
}
