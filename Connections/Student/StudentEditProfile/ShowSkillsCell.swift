//
//  ShowSkillsCell.swift
//  Connections
//
//  Created by Hallam John Ager on 17/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseStorage
import ViewAnimator

extension StudentEditProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillsCell", for: indexPath as IndexPath) as! SkillsCell
        
        let skill = skills[indexPath.row]
        
        cell.skill?.text = skill.skill
        
        return cell
    }
    
}
