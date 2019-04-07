//
//  Comment.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/19/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit

struct Comment: Codable {
    
    let id: Int
    let text: String
    let created_at: String
    let user: User
}
