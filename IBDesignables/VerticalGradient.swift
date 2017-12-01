//
//  VerticalGradient.swift
//  Connections
//
//  Created by Hallam John Ager on 01/12/2017.
//  Copyright © 2017 Hallam John Ager. All rights reserved.
//

import UIKit
@IBDesignable


class VerticalGradient: UIView {

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
        
        
        
        layer.endPoint = CGPoint(x: 0, y: 1) // Upper right corner
        
    }

}
