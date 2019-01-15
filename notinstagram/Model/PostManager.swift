//
//  PostManager.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class PostManager: NSObject {
    
    static func getPosts() -> [Post] {
        let post1 = Post(image: UIImage(named: "city")!, author: "Cam")
        let post2 = Post(image: UIImage(named: "sidewalk")!, author: "NotCam")
        
        return [post1, post2]
    }

}
