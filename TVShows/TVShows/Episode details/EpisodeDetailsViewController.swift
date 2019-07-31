//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 5/5/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

final class EpisodeDetailsViewController: UIViewController {
    
    // MARK: Outlets and variables
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!
    @IBOutlet weak var epSeasonAndEpisodeNumber: UILabel!
    
    var token: String!
    var id: String!
    var imageURL: String!
    var epTitle: String!
    var epDescription: String!
    var epNumber : String!
    var epSeason: String!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        episodeTitle.text = epTitle
        episodeDescription.text = epDescription
        epSeasonAndEpisodeNumber.text = "S\(String(epSeason)) Ep\(String(epNumber))"
        let url = URL(string: "https://api.infinum.academy" + imageURL)
        thumbnail.kf.setImage(with: url, placeholder: UIImage(named: "TV"))
    }

    // MARK: - Actions

    @IBAction func goToPreviousViewController(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func commentButtonActionHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EpisodeComments", bundle: nil)
        let viewController = storyboard.instantiateViewController( withIdentifier: "EpisodeCommentsViewController") as! EpisodeCommentsViewController
        viewController.episodeId = id
        viewController.token = token
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
