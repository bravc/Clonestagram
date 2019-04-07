//
//  Endpoint.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var postParamaters: [String: Any] { get }
    var authNeeded: Bool { get }
    var method: String { get }
}

struct HTTPMethod {
    static let POST: String = "POST"
    static let GET: String = "GET"
}

extension Endpoint {
    var URLComponent: URLComponents {
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = path
        
        return urlComponent!
    }
    
    var request: URLRequest {
        var request = URLRequest(url: URLComponent.url!)
        // make sure auth token is set if needed
        if authNeeded {
            if let token = User.auth_token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        // set request type
        request.httpMethod = method
        
        // add auth header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // set post params if any
        if !postParamaters.isEmpty {
            let json = try? JSONSerialization.data(withJSONObject: postParamaters, options: .prettyPrinted)
            request.httpBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

enum APIEndpoint: Endpoint {
    case postsOfFollowing,
        login(username: String, password: String),
        register(username: String, password: String, name: String),
        logout,
        user(id: Int)
    
    var baseURL: String {
//        return "http://localhost:8000"
        return "https://notinstagramapi.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .postsOfFollowing:
            return "/api/users/following/posts"
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        case .logout:
            return "/api/auth/logout"
        case .user(let id):
            return "/api/users/\(id)"
        }
    }
    
    var postParamaters: [String : Any] {
        switch self {
        case .register(let username, let password, let name):
            return ["email": username, "password": password, "name": name]
        case .login(let username, let password):
            return ["email": username, "password": password]
        default:
            return [:]
        }
    }
    
    var method: String {
        switch self {
        case .login, .register:
            return HTTPMethod.POST
        default:
            return HTTPMethod.GET
        }
    }
    
    var authNeeded: Bool {
        switch self {
        case .login, .register:
            return false
        default:
            return true
        }
    }
}
