//
//  showExperienceCell.swift
//  Connections
//
//  Created by Hallam John Ager on 21/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

protocol ExperienceProfileCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ShowExperienceCell: UITableViewCell {
    
    weak var delegate: ExperienceProfileCellDelegate?
    
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var jobCompany: UILabel!
    
    @IBAction func editExperienceBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
    @IBAction func deleteExperienceBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
