//
//  Post.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var image: UIImage!
    var author: String!
    
    init(image: UIImage, author: String) {
        self.image = image
        self.author = author
    }
}
