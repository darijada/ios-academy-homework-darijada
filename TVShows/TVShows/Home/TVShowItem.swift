//
//  TVShowItem.swift
//  TVShows
//
//  Created by Infinum on 5/6/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import Foundation

struct TVShowItem: Codable {
    let id: String
    let title: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
        case id = "_id"
    }
}
