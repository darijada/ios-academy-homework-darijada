//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 4/26/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        title.text = nil
    }
}

// MARK: - Configure
extension TVShowTableViewCell {
    func configure(with item: TVShowItem) {
        // Here we are using conditional unwrap, meaning if we have the image, use that, if not, fallback to placeholder image.
        thumbnail.image = item.image ?? UIImage(named: "icImagePlaceholder")
        title.text = item.name
    }
}

// MARK: - Private
private extension TVShowTableViewCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 20
    }
}
