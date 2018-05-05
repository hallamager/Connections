//
//  ShowQuestionOne.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 16/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol RemoveAnswerCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ShowAnswer: UITableViewCell {
    
    weak var delegate: RemoveAnswerCellDelegate?
    
    @IBOutlet weak var answer: UITextView!
    @IBOutlet weak var studentImg: UIImageView!
    
    @IBAction func removeAnswerBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
