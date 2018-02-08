//
//  StudentSideMenuTableViewCell.swift
//  Connections
//
//  Created by Hallam John Ager on 08/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

class StudentSideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgMenuIcon: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
