//
//  BusinessLikedCell.swift
//  Connections
//
//  Created by Hallam John Ager on 09/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell


class BusinessLikedCell: FoldingCell {
    
    @IBOutlet weak var foldingNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //Defines sides, shadows and colour of the cells for the viewcontroller.
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 0
        foregroundView.layer.shadowOpacity = 0.5
        foregroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        foregroundView.layer.shadowRadius = 4.0
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
