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
}

class StudentAppliedCell: UITableViewCell {
    
    var student: Student!
    weak var delegate: StudentInviteChatCellDelegate?
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var companyImg: UIImageView!
    @IBOutlet weak var studentHeadline: UILabel!
    
    @IBAction func organiseInterviewBtn(_ sender: UIButton) {
        delegate?.selected(for: student)
    }
    
}
