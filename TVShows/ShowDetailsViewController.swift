//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 4/29/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

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

class ShowDetailsViewController: UIViewController {

    @IBOutlet private weak var episodeTableView: UITableView!
    
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDescription: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private var episodes = [EpisodeDetails]()
    var token: String!
    var id: String!
    var showTitleInput: String!
    var showDescriptionInput: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle.text = showTitleInput
        showDescription.text = showDescriptionInput
        showEpisodes()
        //navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden( true, animated: true)
        setupTableView()
    }
    
    @IBAction func goToPreviousViewController(_ sender: Any) {        
        self.navigationController!.popViewController(animated: true)
    }
}

private extension ShowDetailsViewController {
    
    func showEpisodes() {
        SVProgressHUD.show()
        let headers = ["Authorization": token!]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/" + id + "/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<[EpisodeDetails]>) in
                
                switch response.result {
                case .success(let tvShowEpisodes):
                    print("Success: \(tvShowEpisodes)")
                    self.episodes = tvShowEpisodes
                    self.episodeTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
                SVProgressHUD.dismiss()
        }
    }
}

// MARK: - UITableView
extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        episodeTableView.deselectRow(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        print("Selected Episode: \(episode)")
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        cell.configure(with: episodes[indexPath.row])
        return cell
    }
}

// MARK: - Private
private extension ShowDetailsViewController {
    func setupTableView() {
        //episodeTableView.estimatedRowHeight = 110
        episodeTableView.rowHeight = 50
        episodeTableView.tableFooterView = UIView()
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
    }
}
