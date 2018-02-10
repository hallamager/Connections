//
//  BusinessLikedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 09/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BusinessLikedViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 180
    let kOpenCellHeight: CGFloat = 490
    let ref = Database.database().reference().child("business")
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    var businesses = [Business]()
    var businessContent = BusinessLikedCell()
    

    @IBOutlet var openMenuLeft: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for business in snapshot.children {
                if let data = business as? DataSnapshot {
                    if let business = Business(snapshot: data) {
                        self.businesses.append(business)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            print("is\(self.businesses.count)")
            
        })
        
        //open menu with tab bar button
        openMenuLeft.target = self.revealViewController()
        openMenuLeft.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setup()
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

extension BusinessLikedViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as BusinessLikedCell = cell else {
            return
        }
        
        let business = businesses[indexPath.row]
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.nameLabel.text! = business.username        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let cellContent = tableView.dequeueReusableCell(withIdentifier: "FoldingCell") as! BusinessLikedCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let business = businesses[indexPath.row]
        
        cellContent.nameLabel.text! = business.username
        
        print(business.username)
        
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
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
