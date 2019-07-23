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

    // MARK: Outlets
    
    @IBOutlet private weak var showNumberOfEpisodes: UILabel!
    @IBOutlet private weak var showEpisodeNumber: UILabel!
    @IBOutlet private weak var seasonEpisodeNumber: UILabel!
    @IBOutlet private weak var addNewEpisodeButton: UIButton!
    @IBOutlet private weak var episodeTableView: UITableView!
    @IBOutlet private weak var showTitle: UILabel!
    @IBOutlet private weak var showDescription: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    private var episodes = [EpisodeDetails]()
    var token: String!
    var id: String!
    var showTitleInput: String!
    var showDescriptionInput: String!

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle.text = showTitleInput
        showDescription.text = showDescriptionInput
        showEpisodes()
        self.navigationController?.setNavigationBarHidden( true, animated: true)
        setupTableView()
    }
    
    @IBAction private func goToPreviousViewController(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction private func addNewEpisode() {
        let vc = makeAddEpisodeViewController()
        vc.token = token
        vc.showId = id
        self.present(vc, animated: true, completion: nil)
    }
    
    private func makeAddEpisodeViewController() -> addEpViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "addEp", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "addEpViewController") as! addEpViewController
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
        episodeTableView.rowHeight = 50
        episodeTableView.tableFooterView = UIView()
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
    }
}

extension ShowDetailsViewController: addEpViewControllerDelegate {

    func didAddNewEpisode() {
        showEpisodes()
    }
}
