//
//  PostViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    // MARK:  Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    // MARK:  Properties
    var postModel: TableViewModel?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.dataSource = self
        
        if postModel != nil {
            updateUI()
        }
    }
    
    /// Update the UI
    func updateUI() {
        comments = postModel!.comments
        authorLabel.text = postModel!.user.name
        descLabel.text = postModel!.description
        postImage.imageFromURL(urlString: postModel!.image_url)
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = comments {
            return comments.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        if let comments = comments {
            cell.textLabel?.text = comments[indexPath.row].text
            cell.detailTextLabel?.text = comments[indexPath.row].user.name
        }
        
        return cell
    }
}
