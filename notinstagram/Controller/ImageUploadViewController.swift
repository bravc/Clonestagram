//
//  ImageUploadViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/16/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import Alamofire

class ImageUploadViewController: UIViewController {
    
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var descriptionText: UITextField!
    
    var pickedImage: UIImage?
    
    static var apiURL = "https://notinstagramapi.herokuapp.com/api/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set Notifications for keyboard showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // set picked image settings
        imageToUpload.contentMode = .scaleAspectFit
        imageToUpload.image = pickedImage
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func cannotUploadMessage(message: String) {
        DispatchQueue.main.async {
            let errorAlert = CBAlert.errorAlert(title: "Cannot Upload", message: message)
            
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func uploadPressed(_ sender: Any) {
        if let pickedImage = self.pickedImage {
            // convert image to data
            let imageData = pickedImage.jpegData(compressionQuality: 0.2)
            
            // set up request
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data"
            ]
            var parameters = Dictionary<String, String>()
            parameters["description"] = descriptionText.text
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                multipartFormData.append(imageData!, withName: "image" , fileName: "image", mimeType: "image/jpeg")
                
            }, usingThreshold: UInt64.init(), to: ImageUploadViewController.apiURL, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        // check response code
//                        print("Response code is: \(response.response?.statusCode)")
                        if response.response?.statusCode == 413 {
                            self.cannotUploadMessage(message: "Image too large!")
                        } else if response.response?.statusCode == 201 {
                            self.performSegue(withIdentifier: "imageReturnSegue", sender: self)
                            print("success")
                        } else {
                            self.cannotUploadMessage(message: "An error occurred")
                        }
                    }
                case .failure( _):
                    self.cannotUploadMessage(message: "An error occurred")
                }
            }
        } else {
            self.cannotUploadMessage(message: "An error occurred")

        }
    }
}
