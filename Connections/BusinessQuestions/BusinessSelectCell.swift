//
//  BusinessSelectCell.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 09/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import FoldingCell
import UIKit


protocol BusinessSelectCellDelegate: class {
    func selected(question: Int, for business: Business)
}


class BusinessSelectCell: FoldingCell {
    
    var business: Business!
    weak var delegate: BusinessSelectCellDelegate?
    @IBOutlet var businessSelect: UILabel!
    @IBOutlet var businessIndustry: UILabel!
    @IBOutlet var businessImg: UIImageView!
    @IBOutlet weak var foldedCompanyName: UILabel!
    @IBOutlet weak var foldedCompanyIndustry: UILabel!
    @IBOutlet weak var foldedBusinessImg: UIImageView!
    @IBOutlet weak var questionOne: UILabel!
    @IBOutlet weak var questionTwo: UILabel!
    @IBOutlet weak var questionThree: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
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
    
    @IBAction func questionSelected(_ sender: UIButton) {
        delegate?.selected(question: sender.tag, for: business)
    }
    
}
