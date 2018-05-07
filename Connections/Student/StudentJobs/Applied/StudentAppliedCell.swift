//
//  StudentAppliedCell.swift
//  Connections
//
//  Created by Hallam John Ager on 24/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol StudentInviteChatCellDelegate: class {
    func selected(for student: Student)
    func didTapButton(_ sender: UIButton)
}

class StudentAppliedCell: UITableViewCell {
    
    var student: Student!
    weak var delegate: StudentInviteChatCellDelegate?
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var studentHeadline: UILabel!
    
    @IBAction func organiseInterviewBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        delegate?.selected(for: student)
        print("tapped")

    }
    
    @IBAction func viewProfileBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        delegate?.didTapButton(sender)
        print("tapped")
        
    }
    
}
