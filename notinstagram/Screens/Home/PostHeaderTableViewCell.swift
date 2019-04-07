//
//  PostHeaderTableViewCell.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/21/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class PostHeaderTableViewCell: UITableViewCell {

    // MARK:  Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // MARK:  Properties
    var user: User! {
        didSet {
            self.updateUI()
        }
    }
    
    /// Update the UI based on user
    func updateUI() {
        userName.text = user.name
        profileImage.imageFromURL(urlString: user.profile_pic)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
