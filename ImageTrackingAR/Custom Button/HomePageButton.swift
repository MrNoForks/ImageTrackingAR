//
//  HomePageButton.swift
//  ImageTrackingAR
//
//  Created by Boppo on 17/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import UIKit
@IBDesignable
class HomePageButton: UIButton {
    @IBInspectable
    private var radiusOfButton : CGFloat = 0 {didSet{setNeedsDisplay()}}
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        
        // Drawing code
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: radiusOfButton)
        
        #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).setFill()
        
        roundedRect.fill()
        
    }
  
    


}
