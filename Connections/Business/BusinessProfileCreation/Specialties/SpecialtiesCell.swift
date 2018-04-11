//
//  SpecialtiesCell.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol SpecialtiesCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class SpecialtiesCell: UITableViewCell {
    
    weak var delegate: SpecialtiesCellDelegate?
    
    @IBOutlet var specialties: UILabel!
    
    @IBAction func deleteSpecaltiesBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
