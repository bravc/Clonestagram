//
//  ButtonX.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class ButtonX: UIButton {
    
    var alphaBefore: CGFloat?

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = self.alpha
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.4
        })
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = self.alphaBefore!
        })
    }

}
