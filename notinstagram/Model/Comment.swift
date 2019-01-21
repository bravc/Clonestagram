//
//  Comment.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/19/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    var author: String!
    var text: String!
    
    init(author: String, text: String) {
        self.author = author
        self.text = text
    }
}
