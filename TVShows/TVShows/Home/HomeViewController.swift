//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 4/26/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

struct TVShowItem: Codable {
    let id: String
    let title: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
        case id = "_id"
    }
}

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
    }
}

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    private var items = [TVShowItem]()
    var token: String!

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // REMOVE back button?
        navigationItem.hidesBackButton = true
    
        setupTableView()
        apiCallShows()
        logoutButton.action = #selector(logoutActionHandler)
    }
    
    @objc private func logoutActionHandler() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController( withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        let share = UIApplication.shared.delegate as? AppDelegate
        share?.window?.rootViewController = navigationController
        share?.window?.makeKeyAndVisible()
    }
}

private extension HomeViewController {
    
    func apiCallShows() {
        SVProgressHUD.show()
        let headers = ["Authorization": "token \(String(describing: self.token))"]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<[TVShowItem]>) in
                switch response.result {
                case .success(let tvShows):
                    print("Success: \(tvShows)")
                    self.items = tvShows
                    self.showTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
                SVProgressHUD.dismiss()
        }
    }
    
    func showEpisodes(id: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "id": id
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/" + id,
                method: .get,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data") {(response: DataResponse<ShowDetails>) in
                switch response.result {
                case .success(let tvShowDetails):
                    let storyboard = UIStoryboard(name: "Details", bundle: nil)
                    let viewController = storyboard.instantiateViewController( withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
                    viewController.token = self.token
                    viewController.id = tvShowDetails.id
                   viewController.showTitleInput = tvShowDetails.title
                    viewController.showDescriptionInput = tvShowDetails.description
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                }
                SVProgressHUD.dismiss()
            }
    }
}

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        let itemId = item.id
        print("Selected Item: \(item)")
        showEpisodes(id: itemId)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let deleteCell = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        return [deleteCell]
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowTableViewCell", for: indexPath) as! TVShowTableViewCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

//MARK: - Private

private extension HomeViewController {
    func setupTableView() {
        showTableView.estimatedRowHeight = 110
        showTableView.rowHeight = UITableView.automaticDimension
        showTableView.tableFooterView = UIView()
        showTableView.delegate = self
        showTableView.dataSource = self
    }
}
