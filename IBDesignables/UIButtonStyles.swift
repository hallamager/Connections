//
//  UIButtonStyles.swift
//  Connections
//
//  Created by Hallam John Ager on 01/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import UIKit
@IBDesignable

class UIButtonStyles: UIButton {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0, height: 0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 4.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        
        didSet {
            
            updateView()
            
        }
        
    }
    
    
    
    
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        
        didSet {
            
            updateView()
            
        }
        
    }
    
    
    
    override class var layerClass: AnyClass {
        
        get {
            
            return CAGradientLayer.self
            
        }
        
    }
    
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        
        layer.colors = [ FirstColor.cgColor, SecondColor.cgColor ]
        
        layer.startPoint = CGPoint(x: 0, y: 0) // Upper left corner
        
        
        
        layer.endPoint = CGPoint(x: 1, y: 0) // Upper right corner
        
    }

}
