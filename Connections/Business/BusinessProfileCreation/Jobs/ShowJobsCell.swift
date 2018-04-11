//
//  ShowJobsCell.swift
//  Connections
//
//  Created by Hallam John Ager on 02/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

protocol JobCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class ShowJobsCell: UITableViewCell {
    
    weak var delegate: JobCellDelegate?
    
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var employmentType: UILabel!
    
    @IBAction func editJobBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
    @IBAction func deleteJobBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
