//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 4/26/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
    
    func configure(with item: TVShowItem) {
        title.text = item.title
    }
}

