//
//  OnBoardingViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 18/05/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController {
    
    @IBOutlet var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "logo"),
                           title: "Welcome !",
                           description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                           pageIcon: #imageLiteral(resourceName: "icon-right"),
                           color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "NotOk"),
                           title: "Banks",
                           description: "We carefully verify all banks before add them into the app",
                           pageIcon: #imageLiteral(resourceName: "Ok"),
                           color: UIColor(red: 246/255, green: 247/255, blue: 249/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "NotOk"),
                           title: "Stores",
                           description: "All local stores are categorized for your convenience",
                           pageIcon: #imageLiteral(resourceName: "Ok"),
                           color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = true
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "CreatedProfile")
        
        setupPaperOnboardingView()
        
        view.bringSubview(toFront: skipButton)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension OnBoardingViewController {
    
    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AppContainerViewController")
        self.present(controller, animated: true, completion: nil)

    }
}

// MARK: PaperOnboardingDelegate

extension OnBoardingViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension OnBoardingViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor(red: 8/255, green: 51/255, blue: 78/255, alpha: 1), UIColor.red, UIColor.green][index]
    }
    
}


//MARK: Constants
extension OnBoardingViewController {
    
    private static let titleFont = UIFont(name: "AvenirNext-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "Avenir Next", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
