//
//  ProfileViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/15/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    
    @IBOutlet weak var numPostsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var profile: User?
    
    var posts: [Post]?

    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.dataSource = self
        PostManager.getPosts(completion: {(posts) -> Void in
            self.posts = posts
            self.postCollectionView.reloadData()
        })
        
        if let profile = profile {
            profileName.text = profile.username
            profileBio.text = "This is my bio"
            numPostsLabel.text = "\(profile.posts?.count ?? 0)"
            numFollowersLabel.text = "\(profile.followers ?? 0)"
            numFollowingLabel.text = "\(profile.following ?? 0)"
            navBar.title = profile.username
            
            navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addPressed))
        }
    }
    
    @objc func addPressed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetails" {
            let postDeatilViewController = segue.destination as! PostViewController
            
            let selectedCell = sender as! ProfileCollectionViewCell
            let indexPath = postCollectionView?.indexPath(for: selectedCell)
            
            postDeatilViewController.post = posts?[(indexPath?.row)!]
            
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            profileImage.imageFromURL(urlString: posts[0].image_url)
            return posts.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
        
        if let posts = posts {
            cell.setup(post: posts[indexPath.row])
        }
        
        
        return cell
    }
    
    
}
