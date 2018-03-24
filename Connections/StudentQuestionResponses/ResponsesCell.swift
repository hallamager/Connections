//
//  ResponsesCell.swift
//  Connections
//
//  Created by Hallam John Ager on 24/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FoldingCell

protocol StudentSelectCellDelegate: class {
    func selected(question: Int, for student: Student)
}

class ResponsesCell: FoldingCell {
    
    var student: Student!
    weak var delegate: StudentSelectCellDelegate?
    @IBOutlet weak var studentImg: UIImageView!
    @IBOutlet weak var studentHeadline: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var foldedStudentName: UILabel!
    @IBOutlet weak var foldedStudentHeadline: UILabel!
    @IBOutlet weak var foldedStudentImg: UIImageView!
    
    @IBOutlet var buttons: [UIButton]!
    
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
    
    @IBAction func answerSelected(_ sender: UIButton) {
        delegate?.selected(question: sender.tag, for: student)
    }
    
}
