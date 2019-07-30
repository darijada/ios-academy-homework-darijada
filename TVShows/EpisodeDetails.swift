//
//  EpisodeDetails.swift
//  TVShows
//
//  Created by Infinum on 5/6/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import Foundation

struct EpisodeDetails: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
        case id = "_id"
        case description
        case episodeNumber
        case season
    }
}
