//
//  BusinessMoreInfoViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 30/01/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Koloda

class BusinessMoreInfoViewController: UIViewController {
        
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyIndustry: UILabel!
    @IBOutlet var companyDescription: UITextView!
    @IBOutlet weak var cultureOne: UILabel!
    @IBOutlet weak var cultureTwo: UILabel!
    @IBOutlet weak var cultureThree: UILabel!
    @IBOutlet weak var companySize: UILabel!
    @IBOutlet weak var companyHeadquarters: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var business: Business!
    var specialties = [Specialties]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyIndustry.text = business.industry
        companyName.text = business.username
        companyDescription.text = business.description
        companyHeadquarters.text = business.businessHeadquarters
        cultureOne.text = business.cultureOne
        cultureTwo.text = business.cultureTwo
        cultureThree.text = business.cultureThree
        companySize.text = business.companySize
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            self.companyImage.image = pic
        }
        
        companyDescription.translatesAutoresizingMaskIntoConstraints = true
        companyDescription.sizeToFit()
        companyDescription.isScrollEnabled = false
        
        let refSpecialties = Database.database().reference().child("business").child("valid").child(business.uuid).child("specialties")
        
        refSpecialties.observe(.value, with: { snapshot in
            self.specialties.removeAll()
            for specialties in snapshot.children {
                if let data = specialties as? DataSnapshot {
                    if let specialties = Specialties(snapshot: data) {
                        
                        self.specialties.append(specialties)
                    }
                }
            }
            
            self.collectionView.reloadData()
            
            print("is\(self.specialties.count)")
            
        })
        
    }
    
}

class SpecialtiesMoreInfoCell: UICollectionViewCell {

    @IBOutlet weak var specialties: UILabel!
    
}

extension BusinessMoreInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "specialtiesCell", for: indexPath as IndexPath) as! SpecialtiesMoreInfoCell
        
        let specialtie = specialties[indexPath.row]
        
        cell.specialties?.text = specialtie.specialties
                
        return cell
    }
    
}

