//
//  ViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fabView: UIView!
    @IBOutlet weak var floatingActionButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var postTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up radii
        floatingActionButton.layer.cornerRadius = 30
        fabView.layer.cornerRadius = fabView.frame.size.height / 2;
        
//        navBar.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(addPressed)
        
        navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addPressed))

        
        posts = PostManager.getPosts()
        postTable.dataSource = self
        postTable.delegate = self
        // set menu to initially be closed
        closeMenu()
    }

    @IBAction func floatingActionButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.fabView.transform == .identity {
                // close menu
                self.closeMenu()
            } else {
                // open
                self.fabView.transform = .identity
            }
        })
    }
    
    // Close the menu
    func closeMenu() {
        self.fabView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    @objc func addPressed() {
        
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
    }
    
    @IBAction func profilePressed(_ sender: Any) {
    }
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetails" {
            let detailViewController = segue.destination as! PostViewController
            
            let row = self.postTable.indexPathForSelectedRow!.row
            
            detailViewController.post = posts![row]
        } else if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            
            // TODO Add profile manager
            let profile = User(username: "koolcam", posts: posts!, followers: 200, following: 30)
            
            profileViewController.profile = profile
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts![indexPath.row]
        
        cell.setup(image: post.image, author: post.author)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
