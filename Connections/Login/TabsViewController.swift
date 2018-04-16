//
//  TabsViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 13/10/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class TabsViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var tabsView: ButtonBarView!
    
    let gradient = CAGradientLayer()
    
    let blueInstagramColor = UIColor(red: 8/255.0, green: 80/255.0, blue: 120/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name: "Avenir Next", size:20) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        tabsView.layer.shadowOpacity = 0.3
        tabsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tabsView.layer.shadowRadius = 3.0
        tabsView.layer.shadowColor = UIColor.lightGray.cgColor
        tabsView.clipsToBounds = false
        tabsView.layer.masksToBounds = false
    
        
        gradient.colors = [UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0), UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)]
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = self?.blueInstagramColor
        }
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logIn")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "register")
        return [child_1, child_2]
    }
    
}
