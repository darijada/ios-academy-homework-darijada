//
//  Episode Comments.swift
//  TVShows
//
//  Created by Infinum on 5/6/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import Foundation

struct EpisodeComments: Codable{
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}
