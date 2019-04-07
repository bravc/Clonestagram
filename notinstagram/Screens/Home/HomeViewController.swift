//
//  HomeViewController.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class HomeViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var fabView: UIView!
    @IBOutlet weak var floatingActionButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var postTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK:  Properties
    var imagePicker: UIImagePickerController!
    var pickedImage: UIImage?
    let viewModel = HomeViewModel(client: NotInstagramClient())
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // refresh
        self.postTable.addSubview(self.refreshControl)
        
        // set up radii
        floatingActionButton.layer.cornerRadius = 30
        fabView.layer.cornerRadius = fabView.frame.size.height / 2
        
        // setup views
        self.postTable.estimatedRowHeight = 500
        self.postTable.rowHeight = UITableView.automaticDimension
        navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addPressed))
        
        // declare delegates
        self.postTable.dataSource = self
        self.postTable.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        // Init View model
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
                self.postTable.alpha = 0.0
            } else {
                self.activityIndicator.stopAnimating()
                self.postTable.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            self.present(CBAlert.errorAlert(title: "Error", message: error.localizedDescription), animated: true)
        }
        
        viewModel.reloadData = {
            self.postTable.reloadData()
        }
        
        viewModel.fetchPosts()

        
        // set menu to initially be closed
        closeMenu()
    }
    
    // MARK:  Outlet Actions
    // Refresh posts on drag
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchPosts()
        refreshControl.endRefreshing()
    }

    
    /// Animate the FAB button
    ///
    /// - Parameter sender:
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
        // close menu first
        closeMenu()
        
        // Post detail segue
        if segue.identifier == "postDetails" {
            let detailViewController = segue.destination as! PostViewController

            let postModel = viewModel.tableViewModels[self.postTable.indexPathForSelectedRow!.section]

            detailViewController.postModel = postModel
        }
        else if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            
            profileViewController.user_id = User.myself?.id
        } else if segue.identifier == "uploadSegue" {
            let uploadViewController = segue.destination as! ImageUploadViewController
            if let pickedImage = pickedImage {
                uploadViewController.pickedImage = pickedImage
            }
        }
    }
}

// MARK:  Tableview Datasource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.tableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.postImage.imageFromURL(urlString: viewModel.tableViewModels[indexPath.section].image_url)
        cell.postDesc.text = viewModel.tableViewModels[indexPath.section].description
        cell.authorLabel.text = viewModel.tableViewModels[indexPath.section].user.name
        cell.likesLabel.text = "\(viewModel.tableViewModels[indexPath.section].likes) likes"

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! PostHeaderTableViewCell
        
        cell.user = viewModel.tableViewModels[section].user
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

// MARK:  ImagePickerDelegate
extension HomeViewController: UIImagePickerControllerDelegate {

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

extension HomeViewController: UINavigationControllerDelegate {
    
}

