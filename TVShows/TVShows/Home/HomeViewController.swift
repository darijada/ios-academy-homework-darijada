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

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var showTableView: UITableView!
    
    private var items = [TVShowItem]()
    var token: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupTableView()
        apiCallShows()
    }
}

private extension HomeViewController {
    
    func apiCallShows() {
        SVProgressHUD.show()
        let headers = ["Authorization": token!]
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
}

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
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
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
 */
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
