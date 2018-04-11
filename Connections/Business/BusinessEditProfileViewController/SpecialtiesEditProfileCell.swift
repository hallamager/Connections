//
//  SpecialtiesCell.swift
//  Connections
//
//  Created by Hallam John Ager on 03/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit

protocol DeleteSpecaltiesCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class SpecialtiesEditProfileCell: UICollectionViewCell {
    
    weak var delegate: DeleteSpecaltiesCellDelegate?
    
    @IBOutlet weak var specialties: UILabel!
    
    @IBAction func deleteSpecaltiesBtn(_ sender: UIButton) {
        delegate?.didTapButton(sender)
        print("tapped")
    }
    
}
