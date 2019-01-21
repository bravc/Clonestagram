//
//  CBAlert.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/16/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class CBAlert: UIAlertController {
    
    static func errorAlert(title: String, message: String) -> UIAlertController {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return errorAlert
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
