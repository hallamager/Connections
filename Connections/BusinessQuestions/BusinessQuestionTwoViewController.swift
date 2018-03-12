//
//  BusinessQuestionTwoViewController.swift
//  Connections
//
//  Created by Hallam Ager (i7231033) on 12/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import XLPagerTabStrip

class BusinessQuestionTwoViewController: UIViewController, IndicatorInfoProvider {
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Q2")
    }
    
}
