//
//  BusinessInvitesCell.swift
//  Connections
//
//  Created by Hallam John Ager on 28/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FoldingCell

protocol YourCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class BusinessInvitesCell: FoldingCell {
    
    weak var delegate: YourCellDelegate?
    
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var foldedCompanyImg: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var foldedCompanyName: UILabel!
    @IBOutlet weak var InviteType: UILabel!
    @IBOutlet weak var foldedInviteType: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var response: UILabel!
    @IBOutlet weak var foldedResponse: UILabel!
    @IBOutlet weak var acceptInvite: UIButton!
    
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
    
    @IBAction func acceptInviteBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }
    
}
