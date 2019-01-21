//
//  LoginViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/18/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            UserManager.shared.login(email: emailField.text!, password: passwordField.text!, onSuccess: {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as! ViewController
//                self.present(viewController, animated: true, completion: nil)
                return
            }, onFailure: { error in
                self.present(CBAlert.errorAlert(title: "Could not login", message: error), animated: true)
            }
        )
        } else {
            self.present(CBAlert.errorAlert(title: "Could not login", message: "All fields neccessary"), animated: true)
        }
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        if self.userNameField.transform == .identity {
            if emailField.text != "" && passwordField.text != "" && userNameField.text != "" {
                let sv = UIViewController.displaySpinner(onView: self.view)
                UserManager.shared.register(email: emailField.text!, password: passwordField.text!, username: userNameField.text!, onSuccess: {
                    UIViewController.removeSpinner(spinner: sv)
                    UIView.animate(withDuration: 0.3) {
                        self.userNameField.isHidden = true
                        self.userNameField.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }
                }, onFailure: {_ in
                    self.present(CBAlert.errorAlert(title: "Could not register", message: "Error occurred"), animated: true)
                })
            } else {
                self.present(CBAlert.errorAlert(title: "Could not register", message: "All fields neccessary"), animated: true)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.userNameField.isHidden = false
                self.userNameField.transform = .identity
            }
        }
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
