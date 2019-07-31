//
//  Media.swift
//  TVShows
//
//  Created by Infinum on 5/7/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import Foundation

struct Media: Codable {
    let type: String
    let path: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case path
    }
}
