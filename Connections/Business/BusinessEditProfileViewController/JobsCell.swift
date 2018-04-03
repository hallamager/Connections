//
//  JobsCell.swift
//  Connections
//
//  Created by Hallam John Ager on 03/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

protocol EditJobCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class JobsCell: UITableViewCell {
    
    weak var delegate: EditJobCellDelegate?
    
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var jobType: UILabel!
    
    @IBAction func editJobsBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
