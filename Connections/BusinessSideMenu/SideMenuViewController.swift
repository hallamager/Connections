//
//  SideMenuViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var SideMenuTableView: UITableView!
    
    var menuNameArray:Array = [String]()
    var iconImage:Array = [UIImage]()
    var coverView: UIView?
    var students = [Student]()
    
    override func viewDidLoad() {
        
        // sets color overlay on front view controller
        coverView = UIView(frame: UIScreen.main.bounds)
        coverView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.5)
        
        // sets menu title and image icon
        menuNameArray = ["Home", "Liked", "Chats", "News Feed", "Profile"]
        iconImage = [UIImage(named: "Home-icon")!, UIImage(named: "Liked-icon")!, UIImage(named: "Chats-icon")!, UIImage(named: "News-Feed-icon")!, UIImage(named: "Profile-icon")! ]
        
        let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let student = Student(snapshot: snapshot) {
                self.usernameLabel.text = student.username
                self.students.append(student)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuNameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        
        cell.imgMenuIcon.image = iconImage[indexPath.row]
        cell.lblMenuName.text! = menuNameArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealViewController:SWRevealViewController = self.revealViewController()
        
        let cell:SideMenuTableViewCell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
        
        if cell.lblMenuName.text! == "Home"
        {
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "BusinessSwipeViewController") as! BusinessSwipeViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
        }
        if cell.lblMenuName.text! == "Liked"
        {

            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "BusinessLikedViewController") as! BusinessLikedViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)

            revealViewController.pushFrontViewController(newFrontViewController, animated: true)

        }
        
    }
    
    // disables interactions on front view controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        
        // remove shadow on front view controller
        self.revealViewController().frontViewShadowOffset = CGSize(width: 0, height: 0);
        self.revealViewController().frontViewShadowOpacity = 0.0;
        self.revealViewController().frontViewShadowRadius = 0.0;
        
        
        // displays color overlay view on front view controller
        self.revealViewController().frontViewController.view.addSubview(coverView!)
        
    }
    
    // re-nables interactions on front view controller once menu is closed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
        
        // removes color overlay view on front view controller
        coverView!.removeFromSuperview()
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("There was a problem loggin out")
        }
    }
    
}
