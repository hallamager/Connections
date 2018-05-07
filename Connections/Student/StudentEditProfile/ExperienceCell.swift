//
//  ExperienceCell.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 12/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol ExperienceCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ExperienceCell: UITableViewCell {
    
    weak var delegate: ExperienceCellDelegate?
    
    @IBOutlet var company: UILabel!
    @IBOutlet var title: UILabel!
    
    @IBAction func editExperienceBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        
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
        
        print("tapped")
    }
    
    @IBAction func deleteExperienceBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        
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
        
        print("tapped")
    }
    
}
