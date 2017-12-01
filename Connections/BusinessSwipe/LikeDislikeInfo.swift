//
//  LikeDislikeInfo.swift
//  Connections
//
//  Created by Hallam John Ager on 13/10/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Koloda

extension BusinessSwipeViewController {
    
    @IBAction func likeButton() {
        kolodaView?.swipe(.right)
    }
    @IBAction func dislikeButton() {
        kolodaView?.swipe(.left)
    }
    @IBAction func undoButton() {
        kolodaView?.revertAction()
    }
    
}
