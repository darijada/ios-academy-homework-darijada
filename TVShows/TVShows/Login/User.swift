//
//  User.swift
//  TVShows
//
//  Created by Infinum on 4/24/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}
