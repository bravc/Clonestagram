//
//  PostViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            postImage.image = post.image
        }

    }
}
