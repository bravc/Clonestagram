//
//  PostManager.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostManager: NSObject {
    

    static func getPosts(completion: @escaping ([Post]) -> ()) {
        
        let headers = ["Authorization": "Bearer \(UserManager.shared.authToken ?? "ewrt")"]
        
        print(headers)

        Alamofire.request("http://localhost:8000/api/users/following/posts", headers: headers).responseJSON { response in
            print(response.response!)
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching posts: \(String(describing: response.result.error))")
                    completion([])
                    return
            }
            
            let posts = JSON(value).array?.map { json -> Post in
                
                let comments = JSON(json["comments"]).array?.map { comment in
                    return Comment(author: comment["id"].stringValue, text: comment["text"].stringValue)
                }

                
                return Post(image_url: json["image_url"].stringValue, author: json["author"]["name"].stringValue, description: json["description"].stringValue + "cam is so cool I like him so much this is a test to see the dynamic height of cells", comments: comments!)
            }

            completion(posts ?? [])
            
        }
    }
}
