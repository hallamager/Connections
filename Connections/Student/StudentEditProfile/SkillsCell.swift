//
//  SkillsCell.swift
//  Connections
//
//  Created by Hallam John Ager on 17/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

protocol SkillsCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class SkillsCell: UICollectionViewCell {
    
    weak var delegate: SkillsCellDelegate?
    
    @IBOutlet weak var skill: UILabel!
    
    @IBAction func deleteSkillsBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
