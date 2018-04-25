//
//  EditSkillsRequiredShowCell.swift
//  Connections
//
//  Created by Hallam John Ager on 24/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

extension EditJobsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return skillRequired.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editSkillsRequiredCell", for: indexPath as IndexPath) as! EditSkillsRequiredCell
        
        cell.editSkillRequired?.text = skillRequired[indexPath.row]
        
        cell.delegate = self
        
        return cell
        
    }
    
}
