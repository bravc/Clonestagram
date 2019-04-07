//
//  ViewModel.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import KeychainAccess

class LoginViewModel {
    // MARK: Properties
    private let client: APIClient
    
    // MARK: UI
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    
    var showLoading: (() -> Void)?
    var showError: ((Error) -> Void)?
    var loginSegue: (() -> Void)?
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK:  Login Functions
    func login(username: String, password: String) {
        if let client = client as? NotInstagramClient {
            self.isLoading = true
            let endpoint = APIEndpoint.login(username: username, password: password)
            // attempt login
            client.send(with: endpoint) { (either) in
                switch either {
                case .success(let json):
                    if let json = json as? JSON {
                        guard let user = try? JSONDecoder().decode(User.self, from: json["user"].rawData()) else {
                            self.showError?(APIError.JsonDecoder)
                            return
                        }
                        // set auth token and user then segue
                        User.auth_token = json["access_token"].stringValue
                        User.myself = user
                        self.isLoading = false
                        self.loginSegue?()
                    }
                case .error(let error):
                    self.isLoading = false
                    self.showError?(error)
                }
            }
        }
    }
    
    func register(username: String, password: String, name: String) {
        if let client = client as? NotInstagramClient {
            self.isLoading = true
            let endpoint = APIEndpoint.register(username: username, password: password, name: name)
            // attempt login
            client.send(with: endpoint) { (either) in
                switch either {
                case .success( _):
                    self.isLoading = false
                    self.loginSegue?()
                case .error(let error):
                    self.isLoading = false
                    self.showError?(error)
                }
            }
        }
    }
    
    func logout() {
        if let client = client as? NotInstagramClient {
            self.isLoading = true
            let endpoint = APIEndpoint.logout
            let request = endpoint.request
            // attempt login
            client.genericGet(with: request) { (either) in
                switch either {
                case .success( _):
                    self.isLoading = false
                    self.loginSegue?()
                case .error(let error):
                    self.isLoading = false
                    self.showError?(error)
                }
            }
        }
    }
}
