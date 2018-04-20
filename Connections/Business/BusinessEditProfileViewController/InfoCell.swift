//
//  InfoCell.swift
//  Connections
//
//  Created by Hallam John Ager on 03/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol EditInfoCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class InfoCell: UITableViewCell {
    
    weak var delegate: EditInfoCellDelegate?
    
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyIndustry: UILabel!
    @IBOutlet var companyHeadquarters: UILabel!
    @IBOutlet var companyDecription: UITextView!
    @IBOutlet var companySize: UILabel!
    @IBOutlet var companyWebsite: UILabel!
    
    @IBAction func editInfoBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
