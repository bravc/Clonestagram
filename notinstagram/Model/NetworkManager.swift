//
//  NetworkManager.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/18/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    var apiURL = "http://localhost:8000"
    
    
    /// Make a basic post request to the server
    ///
    /// - Parameters:
    ///   - endpoint: specified endpoint
    ///   - paramaters: paramaters for endpoint
    ///   - completion: function to be run on completion of request
    func basicPOSTRequest(endpoint: String, paramaters: Parameters, onSuccess: @escaping (Data)->(), onFailure: @escaping (String)->()) -> Void {
        Alamofire.request(apiURL + endpoint, method: .post, parameters: paramaters,encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in
            switch response.result {
            case .success:
                // try to return data
                if response.response?.statusCode == 401 {
                    onFailure("Unauthrorized")
                    return
                }
                if let data = response.data {
                    onSuccess(data)
                    return
                }
                onFailure("Failed to retrieve data")
                return
            case .failure(let error):
                onFailure(error.localizedDescription)
                return
            }
        }
    }
}
