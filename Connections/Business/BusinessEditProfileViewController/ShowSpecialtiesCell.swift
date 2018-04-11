//
//  ShowSpecialtiesCell.swift
//  Connections
//
//  Created by Hallam John Ager on 03/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseStorage
import ViewAnimator

extension BusinessEditProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "specialtiesCell", for: indexPath as IndexPath) as! SpecialtiesEditProfileCell
        
        let specialtie = specialties[indexPath.row]
                
        cell.specialties?.text = specialtie.specialties
        
        cell.delegate = self
                
        return cell
    }
    
}
