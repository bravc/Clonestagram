//
//  Post.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var image_url: String!
    var author: String!
    var desc: String!
    var comments: [Comment]!
    
    init(image_url: String, author: String, description: String, comments: [Comment] = []) {
        self.image_url = image_url
        self.author = author
        self.desc = description
        self.comments = comments
    }
}
