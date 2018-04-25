//
//  EditSkillsRequiredCell.swift
//  Connections
//
//  Created by Hallam John Ager on 24/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol DeleteSkillRequiredCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class EditSkillsRequiredCell: UICollectionViewCell {
    
    weak var delegate: DeleteSkillRequiredCellDelegate?
    
    @IBOutlet weak var editSkillRequired: UILabel!
    
    @IBAction func deleteSkillRequiredBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
