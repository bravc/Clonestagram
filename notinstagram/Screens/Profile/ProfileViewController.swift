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
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = ProfileViewModel(client: NotInstagramClient())
    var user_id: Int?
    
    var posts: [Post] {
        if let user = viewModel.user {
            return user.posts ?? []
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCollectionView.dataSource = self
        userView.layer.cornerRadius = 20
        navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(logOut))
        
        if let user_id = self.user_id {
            viewModel.user_id = user_id
        }
        
        self.activityIndicator.hidesWhenStopped = true
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.setupUI()
            }
        }
        
        viewModel.showError = { error in
            self.presentAlert(alert: CBAlert.errorAlert(title: "Could not load profile", message: error.localizedDescription))
        }
        
        viewModel.fetchUser()
    }
    
    func setupUI() {
        if let user = viewModel.user {
            profileImage.imageFromURL(urlString: user.profile_pic)
            profileName.text = user.name
            numFollowingLabel.text = "\(user.following!) following"
            numFollowersLabel.text = "\(user.followers!) followers"
            navBar.title = user.name
            postCollectionView.reloadData()
        }
    }
    
    @objc func logOut() {
        DispatchQueue.main.async {
            let disconnectActionSheet = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
            disconnectActionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (UIAlertAction) in
                print("logging out")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }))
            
            disconnectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(disconnectActionSheet, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetails" {
            let postDeatilViewController = segue.destination as! PostViewController
            
            let post = posts[(postCollectionView.indexPathsForSelectedItems?.first?.row)!]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
            let date = dateFormatter.date(from: post.created_at)
            
            let postModel = TableViewModel(image_url: post.image_url, description: post.description, user: post.user, comments: post.comments, likes: post.likes, id: post.id)

            postDeatilViewController.postModel = postModel
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell

        cell.setup(post: posts[indexPath.row])
        
        return cell
    }
}
