//
//  LogInViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 13/10/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class LogInViewController: UIViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Login")
    }
    
}
