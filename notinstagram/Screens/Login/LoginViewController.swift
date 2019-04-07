//
//  LoginViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/18/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK:  Outlets
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:  Properties
    let viewModel = LoginViewModel(client: NotInstagramClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up text field stuff
        passwordField.delegate = self
        emailField.delegate = self
        passwordField.layer.cornerRadius = 100
        emailField.layer.cornerRadius = 100

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        // Set up view model
        self.activityIndicator.hidesWhenStopped = true
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.showError = { error in
            self.presentAlert(alert: CBAlert.errorAlert(title: "Could not log in", message: error.localizedDescription))
        }
        
        viewModel.loginSegue = {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyboard.instantiateViewController(withIdentifier: "HomeController")
            self.present(UINavigationController(rootViewController: root), animated: true)
        }
    }
    
    // MARK:  Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: [String : AnyObject] = notification.userInfo! as! [String : AnyObject]
        
        let keyboardSize: CGSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey]!.cgRectValue.size
        let offset: CGSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey]!.cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo: [String : AnyObject] = notification.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey]!.cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    // MARK:  Auth Functions
    @IBAction func loginPressed(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            viewModel.login(username: emailField.text!, password: passwordField.text!)
        } else {
            self.presentAlert(alert: CBAlert.errorAlert(title: "Could not login", message: "All fields are required"))
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
}
