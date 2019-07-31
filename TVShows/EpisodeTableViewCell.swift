//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 4/29/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

final class EpisodeTableViewCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet private weak var episodeTitle: UILabel!
    @IBOutlet private weak var seasonNumber: UILabel!

    // MARK: - Lifecycle methods

    override func prepareForReuse() {
        super.prepareForReuse()
        episodeTitle.text = nil
        seasonNumber.text = nil
    }
    
    func configure(with episode: EpisodeDetails) {
        episodeTitle.text = episode.title
        seasonNumber.text = "S\(episode.season) Ep\(episode.episodeNumber)"
    }
}
