//
//  PresentAlert.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
