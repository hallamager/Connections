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

class BusinessSwipeViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var OpenMenuLeft: UIBarButtonItem!
    
    
    let refLikes = Database.database().reference()
    let ref = Database.database().reference().child("business")
    var businesses = [Business]()
    var students = [Student]()
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self

        ref.observeSingleEvent(of: .value, with: { snapshot in
            for business in snapshot.children {
                if let data = business as? DataSnapshot {
                    if let business = Business(snapshot: data) {
                        self.businesses.append(business)
                    }
                }
            }
            
            self.kolodaView.reloadData()
            
            print("is\(self.businesses.count)")
            
        })
        
        //open menu with tab bar button
        OpenMenuLeft.target = self.revealViewController()
        OpenMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func addLiked(_ business: Business) {
        
        
        let newLike = refLikes.child("businessesLiked/").child(business.uuid)
        let dict = [
            Auth.auth().currentUser!.uid: true,
            ]
        
        newLike.updateChildValues(dict)
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let business = sender as? Business else { return }
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
        let business = businesses[index]
        performSegue(withIdentifier: "MoreInfo", sender: business)
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
            
        } else if direction == .left {
            
            addDisliked(self.businesses[counter])
            
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
        
        
        
        print(business.username)
        
        return BusinessSwipeView
        
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
}
