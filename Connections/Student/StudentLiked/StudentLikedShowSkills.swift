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
        
        if collectionView.tag == 2 {
            print("education is\(educations.count)")
            return educations.count
        }
        
        if collectionView.tag == 3 {
            print("skills is\(skills.count)")
            return skills.count
        } else {
            return experiences.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            
            let experiencecell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedExperienceCell", for: indexPath as IndexPath) as! StudentLikedExperienceCell
            
            let experience = experiences[indexPath.row]
            
            experiencecell.company?.text = experience.company
            experiencecell.title?.text = experience.title
            
            return experiencecell
            
        }
        
        if collectionView.tag == 2 {
            
            let educationcell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedEducationCell", for: indexPath as IndexPath) as! StudentLikedEducationCell
            
            let education = educations[indexPath.row]
            
            educationcell.school?.text = education.school
            educationcell.studied?.text = education.studied
            educationcell.grades?.text = education.grades
            
            return educationcell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedSkillsCell", for: indexPath as IndexPath) as! StudentLikedSkillsCell
        
        let skill = skills[indexPath.row]
        
        cell.skill?.text = skill.skill

        return cell
    }
    
}
