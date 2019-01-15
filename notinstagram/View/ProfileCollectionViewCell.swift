//
//  ProfileCollectionViewCell.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/15/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    func setup(post: Post) {
        self.postImage.image = post.image
    }
}
