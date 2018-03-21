//
//  SelectJobCell.swift
//  Connections
//
//  Created by Hallam John Ager on 21/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import FoldingCell
import UIKit


class SelectJobCell: FoldingCell {
    
    @IBOutlet var businessName: UILabel!
    @IBOutlet weak var businessImg: UIImageView!
    @IBOutlet weak var employmentType: UILabel!
    @IBOutlet weak var foldedBusinessImg: UIImageView!
    @IBOutlet weak var foldedBusinessName: UILabel!
    @IBOutlet weak var foldedEmploymentType: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var jobSalary: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobSkillsRequired: UILabel!
    
    //Defines sides, shadows and colour of the cells for the viewcontroller.
    override func awakeFromNib() {
        
        foregroundView.layer.shadowOpacity = 0.3
        foregroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        foregroundView.layer.shadowRadius = 3.2
        foregroundView.layer.shadowColor = UIColor.lightGray.cgColor
        foregroundView.layer.cornerRadius = 10
        
        backgroundColor = .clear
        
        super.awakeFromNib()
    }
    
    //Defines times for flipping animation.
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.20, 0.20, 0.20] // timing animation for each view
        return durations[itemIndex]
        
    }
    
}
