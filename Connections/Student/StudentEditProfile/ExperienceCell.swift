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
        print("tapped")
    }
    
    @IBAction func deleteExperienceBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
