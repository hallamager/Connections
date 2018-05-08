//
//  BusinessLikedShowSpecialties.swift
//  Connections
//
//  Created by Hallam John Ager on 21/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

extension BusinessLikedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 2 {
            print("specialties is\(specialties.count)")
            return specialties.count
        } else {
            return matchedBusinesses.count
        }

    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 2 {
            let specialtiesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedSpecialtiesCell", for: indexPath as IndexPath) as! BusinessLikedSpecialtiesCell
            
            let specialtie = specialties[indexPath.row]
            
            specialtiesCell.specialtie?.text = specialtie.specialties
            
            return specialtiesCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchedCell", for: indexPath as IndexPath) as! MatchedCell
        
        let business = matchedBusinesses[indexPath.row]
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(business.uuid)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            cell.imageView.image = pic
        }
        
        cell.companyName?.text = business.username
        
        return cell
        
    }
    
}
