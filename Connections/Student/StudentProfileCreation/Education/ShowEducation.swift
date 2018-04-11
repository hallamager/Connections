//
//  ShowEducation.swift
//  Connections
//
//  Created by Hallam John Ager on 23/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol EducationProfileCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ShowEducationCell: UITableViewCell {
    
    weak var delegate: EducationProfileCellDelegate?
    
    @IBOutlet var school: UILabel!
    @IBOutlet var studied: UILabel!
    
    @IBAction func editEducationBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
    @IBAction func deleteEducationBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
