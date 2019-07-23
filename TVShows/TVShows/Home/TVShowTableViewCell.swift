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

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    //var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        thumbnail.image = nil
    }
    
    func configure(with item: TVShowItem) {
        title.text = item.title
        let imageUrl = item.imageUrl
        if imageUrl.isEmpty { thumbnail.image = nil}
        else{
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
            thumbnail.kf.setImage(with: url)
        }
    }
}

