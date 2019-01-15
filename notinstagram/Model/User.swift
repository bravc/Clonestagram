//
//  User.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/15/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var username: String?
    var posts: [Post]?
    var followers: Int?
    var following: Int?
    
    init(username: String, posts: [Post], followers: Int, following: Int) {
        self.username = username
        self.posts = posts
        self.followers = followers
        self.following = following
    }
}
