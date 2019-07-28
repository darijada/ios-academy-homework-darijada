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

final class ShowDetailsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var thumbnail: UIImageView!
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
    var imageURL: String?

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle.text = showTitleInput
        showDescription.text = showDescriptionInput
        showEpisodes()
        self.navigationController?.setNavigationBarHidden( true, animated: true)
        setupTableView()
        setImage()
    }
    
    private func setImage() {
        guard
            let imageUrl = imageURL,
            !imageUrl.isEmpty
        else { return }
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        thumbnail.kf.setImage(with: url, placeholder: UIImage(named: "TV"))
    }
    
    private func makeAddEpisodeViewController() -> AddEpViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "addEp", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "addEpViewController") as! AddEpViewController
    }
    
    // MARK: - Actions
    
    @IBAction private func goToPreviousViewController(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction private func addNewEpisode() {
        let addViewController = makeAddEpisodeViewController()
        addViewController.token = token
        addViewController.showId = id
        addViewController.delegate = self
        self.present(addViewController, animated: true, completion: nil)
    }
}

private extension ShowDetailsViewController {
    func showEpisodes() {
        SVProgressHUD.show()
        let headers = ["Authorization": "token \(String(describing: self.token))"]
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
                    print(tvShowEpisodes.count)
                    self.showNumberOfEpisodes.text = "Episodes " + " \(tvShowEpisodes.count)"
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
