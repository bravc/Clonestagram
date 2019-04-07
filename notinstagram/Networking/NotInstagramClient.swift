//
//  NotInstagramClient.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotInstagramClient: APIClient {
    
    func fetch(with endpoint: APIEndpoint, completion: @escaping (Either<Posts>) -> Void) {
        let request = endpoint.request
        get(with: request, completion: completion)
    }
    
    func send(with endpoint: APIEndpoint, completion: @escaping (Either<Any>) -> Void) {
        let request = endpoint.request
        post(with: request, completion: completion)
    }
    
    func getUser(with endpoint: APIEndpoint, completion: @escaping (Either<User>) -> Void) {
        let request = endpoint.request
        genericGet(with: request) { (either) in
            switch either {
            case .success(let data):
                if let data = data as? Data {
                    
                    guard let json = try? JSON(data: data) else {
                        completion(.error(APIError.JsonDecoder))
                        return
                    }
                    print(json)
                    
                    guard var user = try? JSONDecoder().decode(User.self, from: data) else {
                        completion(.error(APIError.JsonDecoder))
                        return
                    }
                    

                    
                    // get a users posts
                    guard let posts = try? JSONDecoder().decode(Posts.self, from: json["posts"].rawData()) else {
                        completion(.error(APIError.JsonDecoder))
                        return
                    }
                    
                    // assign optional params
                    user.followers = json["followers"].int
                    user.following = json["following"].int
                    user.posts = posts
                    
                    completion(.success(user))
                    return
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
