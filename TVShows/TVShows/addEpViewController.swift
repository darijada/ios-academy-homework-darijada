//
//  addEpViewController.swift
//  TVShows
//
//  Created by Infinum on 4/31/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol addEpViewControllerDelegate: class {
    func didAddNewEpisode()
}

class addEpViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var epTitle: UITextField!
    @IBOutlet weak var seasonNumber: UITextField!
    @IBOutlet weak var episodeNumber: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    var token: String?
    var showId: String?
    weak var delegate: addEpViewControllerDelegate?
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.action = #selector(addEpisodeButton)
    }
    
    @objc func addEpisodeButton() {
        guard let showTitle = epTitle.text else { return }
        guard let showSeasonNumber = seasonNumber.text else { return }
        guard let showEpisodeNumber = episodeNumber.text else { return }
        guard let showEpisodeDescription = episodeDescription.text else { return }
        addEpisode( title: showTitle, season: showSeasonNumber, episodeNumber: showEpisodeNumber, description: showEpisodeDescription)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createEpisodeFailureAlert(){
        let alert = UIAlertController(title: "Adding episode failure alert", message: "All fields are required!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}

private extension addEpViewController{
    
    func addEpisode(title: String, season: String, episodeNumber: String, description: String) {
        SVProgressHUD.show()
        if (title.isEmpty || season.isEmpty || episodeNumber.isEmpty || description.isEmpty) {
            self.createEpisodeFailureAlert()
            SVProgressHUD.dismiss()
        }
        else {
            guard let token = self.token else { return }
            let headers = ["Authorization": token]
        let parameters: [String: String] = [
            "showId": showId!,
            "title": title,
            "season": season,
            "episodeNumber" : episodeNumber,
            "description": description
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", completionHandler: { [weak self] (response: DataResponse<EpisodeDetails>) in
                switch response.result {
                case .success(let epDetails):
                    SVProgressHUD.dismiss()
                    print("Success: \(epDetails)")
                    self?.delegate?.didAddNewEpisode()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.createEpisodeFailureAlert()
                }
                SVProgressHUD.dismiss()
            }
        )
        }}
}

