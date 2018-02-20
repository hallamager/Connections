//
//  ShowExperienceAddedViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 19/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowExperienceAddedViewController: UIViewController {
    
    let ref = Database.database().reference().child("student/\(Auth.auth().currentUser!.uid)").child("experience")
    var experiences = [Experience]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addNewJob(_ sender: Any) {
        
    }
    
}

extension ShowExperienceAddedViewController: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        print(experiences.count)
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let experience = experiences[indexPath.row]
        cell.textLabel?.text = experience.company
        return cell
    }
    
}
