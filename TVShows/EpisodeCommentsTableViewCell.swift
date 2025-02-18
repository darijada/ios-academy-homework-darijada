//
//  EpisodeCommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 5/6/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

final class EpisodeCommentsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userComment: UILabel!

    // MARK: - Lifecycle methods

    override func prepareForReuse() {
        super.prepareForReuse()
        userEmail.text = nil
        userComment.text = nil
    }
    
    func configure(with comment: EpisodeComments){
        userEmail.text = comment.userEmail
        userComment.text = comment.text
    }

}
