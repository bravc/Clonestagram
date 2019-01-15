//
//  FloatingActionButton.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class FloatingActionButton: ButtonX {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var alpaBefore: CGFloat?
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alpaBefore = self.alpha
        
        // rotate the
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
                self.backgroundColor = #colorLiteral(red: 0.5208124944, green: 0.793171121, blue: 1, alpha: 1)
            } else {
                self.transform = .identity
                self.backgroundColor = #colorLiteral(red: 0.5527986104, green: 0.9612346477, blue: 1, alpha: 1)
            }
        })
        
        
        return super.beginTracking(touch, with: event)
    }

}
