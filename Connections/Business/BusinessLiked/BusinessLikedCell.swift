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

protocol ViewJobCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class BusinessLikedCell: FoldingCell {
    
    weak var delegate: ViewJobCellDelegate?
    
    @IBOutlet weak var foldingNameLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet var companyIndustry: UILabel!
    @IBOutlet var companyImg: UIImageView!
    @IBOutlet var companyHeadquarters: UILabel!
    @IBOutlet var companyImgFolded: UIImageView!
    @IBOutlet var companyDescription: UITextView!
    @IBOutlet var companyWebsite: UILabel!
    @IBOutlet var companyIndustryFolded: UILabel!
    @IBOutlet var companySize: UILabel!
    @IBOutlet var companyHeadquartersFolded: UILabel!
    @IBOutlet weak var jobsPosted: UILabel!
    @IBOutlet weak var specialtiesCollectionView: UICollectionView!
    
    //Defines sides, shadows and colour of the cells for the viewcontroller.
    override func awakeFromNib() {
        
        foregroundView.layer.shadowOpacity = 0.3
        foregroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        foregroundView.layer.shadowRadius = 3.2
        foregroundView.layer.shadowColor = UIColor.lightGray.cgColor
        foregroundView.layer.cornerRadius = 10
        
        companyDescription.translatesAutoresizingMaskIntoConstraints = true
        companyDescription.sizeToFit()
        
        backgroundColor = .clear
        
        super.awakeFromNib()
    }
    
    //Defines times for flipping animation.
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.20, 0.20, 0.20, 0.20] // timing animation for each view
        return durations[itemIndex]
    }
    
    @IBAction func viewJobsBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
    @IBAction func answerCompanyQuestionsBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
