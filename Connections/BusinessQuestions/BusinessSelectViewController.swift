//
//  BusinessSelectViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 15/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FoldingCell
import ViewAnimator

class BusinessSelectViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    let ref = Database.database().reference().child("business")
    var businesses = [Business]()
    let kCloseCellHeight: CGFloat = 130
    let kOpenCellHeight: CGFloat = 340
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadRelatedBusinesses(for: Auth.auth().currentUser!.uid) { success, businesses in
            self.businesses = businesses
            self.tableView.reloadData()
            self.tableView.animateViews(animations: self.animations, delay: 0.3)
        }
                
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    func loadRelatedBusinesses(for studentUID: String, completion: @escaping (Bool, [Business]) -> ()) {
        
        let ref = Database.database().reference(withPath: "matches/" + Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            var uids = [String]()
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                uids.append(userData.key)
            }
            
            let userRef = Database.database().reference(withPath: "business")
            var businesses = [Business]()
            var count = 0
            if uids.count != 0 {
                uids.forEach { uid in
                    userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                        let business = Business(snapshot: snapshot)
                        businesses.append(business!)
                        count += 1
                        if count == uids.count {
                            completion(true, businesses)
                        }
                    }
                }
            } else {
                completion(true, businesses)
            }
        }
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? (tag: Int, business: Business) else { return }
        
        let vc = segue.destination as! BusinessQuestionsListViewController
        vc.business = sender.business
        vc.questionNumber = sender.tag
        
    }
    
}

extension BusinessSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as BusinessSelectCell = cell else {
            return
        }
        
        let business = businesses[indexPath.row]
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.businessSelect?.text = business.username
        cell.businessIndustry?.text = business.industry
        cell.foldedCompanyName?.text = business.username
        cell.foldedCompanyIndustry?.text = business.industry
        cell.questionOne?.text = business.questionOne
        cell.questionTwo?.text = business.questionTwo
        cell.questionThree?.text = business.questionThree
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.businessImg.image = pic
            cell.foldedBusinessImg.image = pic
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
//        
//        let Storyboard = UIStoryboard(name: "BusinessMain", bundle: nil)
//        let vc = Storyboard.instantiateViewController(withIdentifier: "BusinessQuestionsListViewController") as! BusinessQuestionsListViewController
//        vc.business = businesses[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
    
}

extension BusinessSelectViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(businesses.count)
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BusinessSelectCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let business = businesses[indexPath.row]
        cell.business = business
        cell.delegate = self
        print(business.username)
        
        return cell
        
    }
    
}

extension BusinessSelectViewController: BusinessSelectCellDelegate {
    
    func selected(question: Int, for business: Business) {
        print(question)
        print(business)
        
        performSegue(withIdentifier: "QuestionSelected", sender: (tag: question, business: business))
    }
    
}

