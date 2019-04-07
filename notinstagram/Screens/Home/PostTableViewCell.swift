//
//  PostTableViewCell.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    // MARK:  Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func likePressed(_ sender: Any) {
    }
    
    @IBAction func commentPressed(_ sender: Any) {
    }
    
    @IBAction func sharePressed(_ sender: Any) {
    }
}
