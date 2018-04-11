//
//  Education.swift
//  Connections
//
//  Created by Hallam John Ager on 11/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol EducationCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class EducationCell: UITableViewCell {
    
    weak var delegate: EducationCellDelegate?
    
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
