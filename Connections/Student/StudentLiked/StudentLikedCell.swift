//
//  StudentLikedCell.swift
//  Connections
//
//  Created by Hallam John Ager on 11/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import Firebase
import FirebaseDatabase

protocol StudentSelectChatCellDelegate: class {
    func selected(for student: Student)
    
    func didTapButton(_ sender: UIButton)
}

class StudentLikedCell: FoldingCell {
    
    var skills = [Skills]()
    var students = [Student]()
    var student: Student!
    weak var delegate: StudentSelectChatCellDelegate?

    @IBOutlet weak var studentImg: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentHeadline: UILabel!
    @IBOutlet weak var studentFoldedImg: UIImageView!
    @IBOutlet weak var studentFoldedName: UILabel!
    @IBOutlet weak var studentFoldedHeadline: UILabel!
    @IBOutlet weak var studentSummary: UITextView!
    @IBOutlet weak var interestOne: UILabel!
    @IBOutlet weak var interestTwo: UILabel!
    @IBOutlet weak var interestThree: UILabel!
    @IBOutlet weak var organiseChat: UIButtonStyles!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var educationCollectionView: UICollectionView!
    @IBOutlet weak var experienceCollectionView: UICollectionView!
    
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
        let durations = [0.20, 0.20, 0.20, 0.20] // timing animation for each view
        return durations[itemIndex]
    }
    
    @IBAction func organiseChatBtn(_ sender: UIButton) {
        delegate?.selected(for: student)
    }
    
    @IBAction func questionAnswersBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
