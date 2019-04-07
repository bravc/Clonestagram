//
//  User.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/15/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON

struct User: Codable {
    
    // static ref to logged in user
    static var myself: User? {
        set {
            guard let user = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            // store user in keychain
            keychain!["user"] = String(data: user, encoding: .utf8)
            return
        }
        
        get {
            guard let userString = try? User.keychain!.get("user") else {
                return nil
            }
            
            guard let user = try? JSONDecoder().decode(User.self, from: (userString?.data(using: .utf8))!) else {
                return nil
            }
            
            return user
        }
    }
    
    // ref to keychain
    static var keychain: Keychain? {
        return Keychain(service: "api")
    }
        
    let id: Int
    let name: String
    let email: String
    let created_at: String
    let profile_pic: String
    
    // optional properties for profile
    var followers: Int?
    var following: Int?
    var posts: [Post]?
    
    // optional authtoken of user
    static var auth_token: String? {
        set {
            keychain!["auth_token"] = newValue
        }
        
        get {
            guard let token = try? User.keychain!.get("auth_token") else {
                return nil
            }
    
            return token
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case created_at
        case profile_pic
        case email
    }
}
