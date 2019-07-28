//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 4/26/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import Kingfisher

final class TVShowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    //var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    func configure(with item: TVShowItem) {
        titleLabel.text = item.title
        let imageUrl = item.imageUrl
        if imageUrl.isEmpty { thumbnailImageView.image = nil}
        else{
            let url = URL(string: "https://api.infinum.academy" + imageUrl)
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

