//
//  ViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var fabView: UIView!
    @IBOutlet weak var floatingActionButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var postTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var imagePicker: UIImagePickerController!
    var pickedImage: UIImage?
    var posts: [Post]?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    // Refresh posts on drag
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        PostManager.getPosts(completion: {(posts) -> Void in
            self.posts = posts

        })
        self.postTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // refresh
        self.postTable.addSubview(self.refreshControl)
        
        // set up radii
        floatingActionButton.layer.cornerRadius = 30
        fabView.layer.cornerRadius = fabView.frame.size.height / 2
        
        self.postTable.estimatedRowHeight = 500
        self.postTable.rowHeight = UITableView.automaticDimension
        
        self.postTable.dataSource = self
        self.postTable.delegate = self
        navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addPressed))

        
        
        
        // get initial posts
        PostManager.getPosts(completion: {(posts) -> Void in
            self.posts = posts
            self.postTable.reloadData()
        })
        
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
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
    }
    
    @IBAction func profilePressed(_ sender: Any) {
    }
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Post detail segue
        if segue.identifier == "postDetails" {
            let detailViewController = segue.destination as! PostViewController
            
            let row = self.postTable.indexPathForSelectedRow!.row
            
            detailViewController.post = posts![row]
        // profile segue
        } else if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            
            // TODO Add profile manager
            let profile = User(username: "koolcam", posts: posts!, followers: 200, following: 30)
            
            profileViewController.profile = profile
        } else if segue.identifier == "uploadSegue" {
            let uploadViewController = segue.destination as! ImageUploadViewController
            if let pickedImage = pickedImage {
                uploadViewController.pickedImage = pickedImage
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = posts {
            return 1
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts![indexPath.row]
        cell.setup(post: post)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // dismiss image picker menu
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImage = pickedImage
            performSegue(withIdentifier: "uploadSegue", sender: self)
        } else {
            // show alert for menu
            DispatchQueue.main.async {
                let errorAlert = CBAlert.errorAlert(title: "Cannot Upload", message: "No Photo Chosen!")
                
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

