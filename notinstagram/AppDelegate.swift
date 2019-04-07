//
//  AppDelegate.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // decide which storyboard to present based on past logins
        window?.makeKeyAndVisible()
        window?.rootViewController?.present(chooseViewController(autoLogin: true), animated: false, completion: nil)
        return true
    }
    
    func chooseViewController(autoLogin: Bool) -> UIViewController {
//        if let _ = User.auth_token, autoLogin {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let root = storyboard.instantiateViewController(withIdentifier: "HomeController")
//            return UINavigationController(rootViewController: root)
//        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        }
    }
}

