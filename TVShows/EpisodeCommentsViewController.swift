//
//  EpisodeCommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 5/6/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import Kingfisher
import SVProgressHUD
import TBEmptyDataSet

final class EpisodeCommentsViewController: UIViewController {
    
    // MARK: Outlets and variables
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var textFieldViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var token: String!
    var episodeId: String!
    private var comments = [EpisodeComments]()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showComments()
        setupTableView()
        configureTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        commentsTableView.emptyDataSetDataSource = self
        commentsTableView.emptyDataSetDelegate = self
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(EpisodeCommentsViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.view.frame.origin.y = -keyboardReact.height
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    private func emptyCommentFailureAlert(){
        let alert = UIAlertController(title: "Comment failure alert", message: "Comment field is required!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
     // MARK: Actions
    
    @IBAction func backButtonActionHandler(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        postComment()
        view.endEditing(true)
        commentTextField.text = nil
        showComments()
    }
}

    // MARK: - UITableView

extension EpisodeCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commentsTableView.deselectRow(at: indexPath, animated: true)
        let comment = comments[indexPath.row]
        print(comment)
    }
}

extension EpisodeCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCommentsTableViewCell", for: indexPath) as! EpisodeCommentsTableViewCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension EpisodeCommentsViewController {
    func setupTableView() {
        commentsTableView.estimatedRowHeight = 110
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.tableFooterView = UIView()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
}

private extension EpisodeCommentsViewController {
    
    func showComments() {
        SVProgressHUD.show()
        let headers = ["Authorization": "token \(String(describing: self.token))"]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/" + episodeId + "/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<[EpisodeComments]>) in
                switch response.result {
                case .success(let episodeComments):
                    print("Success: \(episodeComments)")
                    self.comments = episodeComments
                    print(episodeComments.count)
                    self.commentsTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
                SVProgressHUD.dismiss()
        }
    }
    
    func postComment(){
        SVProgressHUD.show()
        guard let userComment = commentTextField.text else { return }
        if userComment.isEmpty
        {
            emptyCommentFailureAlert()
        }
        else {
            guard let token = self.token else { return }
            let headers = ["Authorization": token]
            let parameters: [String: String] = [
                "text": userComment,
                "episodeId": self.episodeId,
            ]
            Alamofire
                .request(
                    "https://api.infinum.academy/api/comments",
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", completionHandler: { [weak self] (response: DataResponse<EpisodeComments>) in
                    switch response.result {
                    case .success(let episodeComment):
                        SVProgressHUD.dismiss()
                        print("Success: \(episodeComment)")
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                    SVProgressHUD.dismiss()
                    }
            )
        }
    }
}

extension EpisodeCommentsViewController: TBEmptyDataSetDataSource {

    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "img-placehoder-comments")
    }
    
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        var attributes: [NSAttributedString.Key: Any]?
        attributes = [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.gray]
        return NSAttributedString(string: "Sorry, we don't have comments yet. Be first who will write a review.", attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return -80
    }
}

extension EpisodeCommentsViewController: TBEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return comments.count == 0
    }
}
