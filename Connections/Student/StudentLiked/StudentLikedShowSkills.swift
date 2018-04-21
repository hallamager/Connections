//
//  StudentLikedShowSkills.swift
//  Connections
//
//  Created by Hallam John Ager on 21/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import Firebase

extension StudentLikedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("skills is\(skills.count)")
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedSkillsCell", for: indexPath as IndexPath) as! StudentLikedSkillsCell
        
        let skill = skills[indexPath.row]
        
        cell.skill?.text = skill.skill
                
        return cell
    }
    
}
