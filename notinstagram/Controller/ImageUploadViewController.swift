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
    
    var pickedImage: UIImage?
    
    var apiURL = "http://localhost:8000/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToUpload.contentMode = .scaleAspectFit
        imageToUpload.image = pickedImage
    }
    
    
    @IBAction func uploadPressed(_ sender: Any) {
        if let pickedImage = self.pickedImage {
            
            let imageData = pickedImage.jpegData(compressionQuality: 0.2)
            
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data"
            ]
            
            var parameters = Dictionary<String, String>()
            
            parameters["description"] = "gdfsgsdf"
            parameters["image_url"] = "sgfsddfsgs"
            
//            let user = posts![0].author
            

            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                multipartFormData.append(imageData!, withName: "image" , fileName: "werte.png", mimeType: "image/jpeg")
                
                
            }, usingThreshold: UInt64.init(), to: self.apiURL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Response code is: \(response.response?.statusCode)")
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                }
            }
        } else {
            print("not image")
        }
    }
    

}
