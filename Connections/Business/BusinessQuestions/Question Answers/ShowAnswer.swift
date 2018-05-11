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
    @IBOutlet weak var studentAnswer: UITextView!
    @IBOutlet weak var studentImg: UIImageView!
    @IBOutlet weak var studentProfilePic: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var likedBtn: UIButtonStyles!
    @IBOutlet weak var likedImg: UIImageView!
    @IBOutlet weak var likedStatus: UILabel!
    
    @IBAction func removeAnswerBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
    @IBAction func likeBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        
        likedBtn.backgroundColor = UIColor(red: 8/255, green: 80/255, blue: 120/255, alpha: 1.0)
        likedImg.image = #imageLiteral(resourceName: "ThumbsUpWhite")
        
        print("tapped")
    }
    
}
