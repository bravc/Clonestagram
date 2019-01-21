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
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.dataSource = self
        if let post = post {
            postImage.imageFromURL(urlString: post.image_url)
            authorLabel.text = post.author
            descLabel.text = post.desc
            
            
        }

    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let post = post {
            return post.comments.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        cell.detailTextLabel?.text = post!.comments[indexPath.row].text
        cell.textLabel?.text = post!.comments[indexPath.row].author
        return cell
    }


}
