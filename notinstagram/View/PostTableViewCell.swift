//
//  PostTableViewCell.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var savePressed: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(image: UIImage, author: String) {
        self.postImage.image = image
        self.postAuthor.text = author
    }

    @IBAction func favPressed(_ sender: Any) {
    }
    
    @IBAction func savePressed(_ sender: Any) {
    }
}
