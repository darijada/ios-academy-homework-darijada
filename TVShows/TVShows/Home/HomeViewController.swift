//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 4/26/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

struct TVShowItem {
    let name: String
    let image: UIImage?
}

final class HomeViewController: UIViewController {

    @IBOutlet private weak var showTableView: UITableView!
    
    private let items = [
        TVShowItem(name: "Fringe", image: nil),
        TVShowItem(name: "Dexter", image: nil),
        TVShowItem(name: "Fringe", image: nil),
        TVShowItem(name: "Dexter", image: nil),
        TVShowItem(name: "Fringe", image: nil),
        TVShowItem(name: "Dexter", image: nil),
        TVShowItem(name: "Fringe", image: nil),
        TVShowItem(name: "Dexter", image: nil),
        TVShowItem(name: "Fringe", image: nil),
        TVShowItem(name: "Dexter", image: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

    // MARK: - UITableView
    extension HomeViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            showTableView.deselectRow(at: indexPath, animated: true)
            let item = items[indexPath.row]
            print("Selected Item: \(item)")
        }
    }
    
    extension HomeViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            
            let cell = showTableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell
            
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



