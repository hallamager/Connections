//
//  SkillsRequiredShowCell.swift
//  Connections
//
//  Created by Hallam John Ager on 23/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

extension AddJobsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return skillRequired.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillsRequiredCell", for: indexPath as IndexPath) as! SkillsRequiredCell

        cell.skillRequired?.text = skillRequired[indexPath.row]

        return cell
        
    }
    
}
