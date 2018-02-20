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
    
    var experiences = [Experience]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddExperienceViewController
        vc.delegate = self
    }
    
    @IBAction func addNewJob(_ sender: Any) {
    }
    
}

extension ShowExperienceAddedViewController: AddExperienceControllerDelegate {
    
    func didAddExperience(_ experience: Experience) {
        
        experiences.append(experience)
        tableView.reloadData()
        
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
