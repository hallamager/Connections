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
                           title: "Welcome",
                           description: "Welcome to connections. The chance to find the perfect business or employee is now right at your fingertips.",
                           pageIcon: #imageLiteral(resourceName: "onBoardingIndicator"),
                           color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "CardExample"),
                           title: "Liking & Matching",
                           description: "Swipe right to like or left to pass. If you need more information, just give the card a tap. Keep in mind, businesses will only see students that have liked them.",
                           pageIcon: #imageLiteral(resourceName: "onBoardingIndicator"),
                           color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Answers"),
                           title: "Questions",
                           description: "As businesses you have the chance to ask students three questions. Pick carfully as this is a great opportunity to get to know your future employees better. As students, this is a chance to give businesses a better insight into who you really are, only increasing the chances of creating the best possible connections.",
                           pageIcon: #imageLiteral(resourceName: "onBoardingIndicator"),
                           color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                           titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Jobs"),
                           title: "Jobs and Interviews",
                           description: "Hassle free apply for jobs and organise interviews with matched students and businessses.",
                           pageIcon: #imageLiteral(resourceName: "onBoardingIndicator"),
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
        skipButton.isHidden = index == 3 ? false : true
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
        return 4
    }
    
        func onboardinPageItemRadius() -> CGFloat {
            return 1
        }
    
        func onboardingPageItemSelectedRadius() -> CGFloat {
            return 1
        }
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor(red: 8/255, green: 51/255, blue: 78/255, alpha: 1), UIColor(red: 8/255, green: 51/255, blue: 78/255, alpha: 1), UIColor(red: 8/255, green: 51/255, blue: 78/255, alpha: 1), UIColor(red: 8/255, green: 51/255, blue: 78/255, alpha: 1)][index]
    }
    
}


//MARK: Constants
extension OnBoardingViewController {
    
    private static let titleFont = UIFont(name: "AvenirNext-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "Avenir Next", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
