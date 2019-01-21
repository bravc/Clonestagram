//
//  UserManager.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/18/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserManager: NSObject {
    
    
    /// Singleton usermanager
    static let shared = UserManager()
    
    /// User's auth token
    var authToken: String?
    
    
    /// Login to the api
    ///
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    func login(email: String, password: String, onSuccess: @escaping ()->(), onFailure: @escaping (String)->()) {
        let paramaters: Parameters = [
            "email": email,
            "password": password
        ]
        
        return NetworkManager.shared.basicPOSTRequest(endpoint: "/api/auth/login", paramaters: paramaters,
            onSuccess: { (responseData: Data) in
                if let json = try? JSON(data: responseData) {
                    self.authToken = json["access_token"].stringValue
                    onSuccess()
                    return
                }
                onFailure("Failed")
                return
            }, onFailure: { (error: String) in
                onFailure(error)
                return
        })
    }
    
    
    /// Register for the application
    ///
    /// - Parameters:
    ///   - email: email of user
    ///   - password: password of user
    ///   - username: username of user
    func register(email: String, password: String, username: String, onSuccess: @escaping ()->(), onFailure: @escaping (String)->() = {_ in }) {
        let paramaters: Parameters = [
            "email": email,
            "password": password,
            "name": username
        ]
        
        return NetworkManager.shared.basicPOSTRequest(endpoint: "/api/auth/register", paramaters: paramaters,
          onSuccess: { (responseData: Data) in
            if let json = try? JSON(data: responseData) {
                onSuccess()
            }
        }, onFailure: { (error: String) in
            onFailure(error)
        })
    }
}
