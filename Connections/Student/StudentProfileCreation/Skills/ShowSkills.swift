//
//  ShowSkills.swift
//  Connections
//
//  Created by Hallam John Ager on 25/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol DeleteSkillsCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ShowSkillCell: UITableViewCell {
    
    weak var delegate: DeleteSkillsCellDelegate?
    
    @IBOutlet var skill: UILabel!
    
    @IBAction func deleteSkillBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
