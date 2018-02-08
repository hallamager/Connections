//
//  LikeDislikeButtons.swift
//  Connections
//
//  Created by Hallam John Ager on 08/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Koloda

extension StudentSwipeViewController {
    
    @IBAction func likeButton() {
        kolodaView?.swipe(.right)
    }
    @IBAction func dislikeButton() {
        kolodaView?.swipe(.left)
    }
    
}
