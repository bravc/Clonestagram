//
//  ApiClient.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/22/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Either<T> {
    case success(T)
    case error(Error)
}

enum APIError: Error {
    case unknown, badResponse, JsonDecoder, notAuthorized, noData, imageDownload, imageConvert
}

extension Error {
    var clientError: String {
        return "An error occured, please try again"
    }
}

protocol APIClient {
    func get<T: Codable>(with request: URLRequest, completion: @escaping (Either<[T]>) -> Void)
    func post(with request: URLRequest, completion: @escaping (Either<Any>) -> Void)
}

extension APIClient {
    func get<T: Codable>(with request: URLRequest, completion: @escaping (Either<[T]>) -> Void) {
        Alamofire.request(request).response { (response) in
            // if not in success range
            print(response.response)
            if !(200..<300 ~= response.response!.statusCode) {
                completion(.error(APIError.badResponse))
                return
            }
            // make sure response has data
            guard let data = response.data else {
                completion(.error(APIError.noData))
                return
            }

            // decode into object form
            let decoder = JSONDecoder()
            guard let value = try? decoder.decode([T].self, from: data) else {
                completion(.error(APIError.JsonDecoder))
                return
            }
            
            // return converted object
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
    }
    
    func genericGet(with request: URLRequest, completion: @escaping (Either<Any>) -> Void) {
        Alamofire.request(request).response { (response) in
            // if not in success range
            if !(200..<300 ~= response.response!.statusCode) {
                completion(.error(APIError.badResponse))
                return
            }
            // make sure response has data
            guard let data = response.data else {
                completion(.error(APIError.noData))
                return
            }
            
            // return converted object
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
    
    func post(with request: URLRequest, completion: @escaping (Either<Any>) -> Void) {
        Alamofire.request(request).response { (response) in
            if response.response == nil {
                completion(.error(APIError.unknown))
                return
            }
                        
            // if not in success range
            if !(200..<300 ~= response.response!.statusCode) {
                completion(.error(APIError.badResponse))
                return
            }
            
            // make sure response has data
            guard let data = response.data else {
                completion(.error(APIError.noData))
                return
            }
            
            guard let json = try? JSON(data: data) else {
                completion(.error(APIError.JsonDecoder))
                return
            }
            
            // return converted object
            DispatchQueue.main.async {
                completion(.success(json))
            }
        }
    }
}
