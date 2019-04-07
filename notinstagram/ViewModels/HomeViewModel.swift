//
//  ViewModel.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import UIKit

// Model to represent a single post cell
struct TableViewModel {
    let image_url: String
    let description: String
    let user: User
    let comments: [Comment]
    let likes: Int
    let id: Int
}

class HomeViewModel {
    // MARK: Properties
    private let client: APIClient
    private var posts: Posts = [] {
        didSet {
            self.fetchPost()
        }
    }
    var tableViewModels: [TableViewModel] = []
    
    // MARK: UI
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK:  Post Functions
    
    /// Get all posts from followers
    func fetchPosts() {
        if let client = client as? NotInstagramClient {
            self.isLoading = true
            let endpoint = APIEndpoint.postsOfFollowing
            client.fetch(with: endpoint) { (either) in
                switch either {
                case .success(let posts):
                    self.posts = posts
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    
    
    /// Fetch the actual posts from posts
    private func fetchPost() {
        self.posts.forEach { (post) in
            
            self.tableViewModels.append(TableViewModel(image_url: post.image_url, description: post.description, user: post.user, comments: post.comments, likes: post.likes, id: post.id))
        }
        
        
        self.isLoading = false
        self.reloadData?()
    }
}
