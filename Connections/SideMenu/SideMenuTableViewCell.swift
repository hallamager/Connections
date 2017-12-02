//
//  SideMenuTableViewCell.swift
//  Connections
//
//  Created by Hallam John Ager on 02/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgMenuIcon: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
