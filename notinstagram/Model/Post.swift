//
//  Post.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

typealias Posts = [Post]

struct Post: Codable {
    
    let id: Int
    let description: String
    let image_url: String
    let likes: Int
    let user: User
    let created_at: String
    let comments: [Comment] = []
    
}
