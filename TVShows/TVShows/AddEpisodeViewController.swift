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

protocol AddEpisodeViewControllerDelegate: class {
    func didAddNewEpisode()
}

final class AddEpisodeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var episodeTitle: UITextField!
    @IBOutlet weak var seasonNumber: UITextField!
    @IBOutlet weak var episodeNumber: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var token: String?
    var showId: String?
    var mediaID: String?
    weak var delegate: AddEpisodeViewControllerDelegate?
    var image: UIImage?
    var media: Media?
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addButton.action = #selector(addEpisodeButton)
    }
    
    private func createEpisodeFailureAlert(){
        let alert = UIAlertController(title: "Adding episode failure alert", message: "All fields are required!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addEpisodeButton() {
        guard let showTitle = episodeTitle.text else { return }
        guard let showSeasonNumber = seasonNumber.text else { return }
        guard let showEpisodeNumber = episodeNumber.text else { return }
        guard let showEpisodeDescription = episodeDescription.text else { return }
        addEpisode( title: showTitle, season: showSeasonNumber, episodeNumber: showEpisodeNumber, description: showEpisodeDescription)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func uploadPhotoButtonHandler(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: Private

private extension AddEpisodeViewController{
    
    func addEpisode(title: String, season: String, episodeNumber: String, description: String) {
        SVProgressHUD.show()
        if (title.isEmpty || season.isEmpty || episodeNumber.isEmpty || description.isEmpty) {
            self.createEpisodeFailureAlert()
            SVProgressHUD.dismiss()
        }
        else {
            guard let token = token else { return }
            let headers = ["Authorization": token]
        var parameters: [String: String] = [
            "showId": showId!,
            "title": title,
            "season": season,
            "episodeNumber" : episodeNumber,
            "description": description
        ]
            
            if let id = media?.id {
            parameters["mediaId"] = id
        }
        
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
                case .success(let episodeDetails):
                    SVProgressHUD.dismiss()
                    print("Success: \(episodeDetails)")
                    self?.delegate?.didAddNewEpisode()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.createEpisodeFailureAlert()
                }
                SVProgressHUD.dismiss()
            }
        )
        }
    }
    
    func uploadImageOnAPI(image: UIImage) {
        guard let token = self.token else { return }
        let headers = ["Authorization": token]
        let someUIImage = image
        let imageByteData = someUIImage.pngData()!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                } }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    
                    self.media = media
                    
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                case .failure(let error):
                    print("FAILURE: \(error)")
                } }
    }
}

extension AddEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
            uploadImageOnAPI(image: image!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

extension AddEpisodeViewController: UINavigationControllerDelegate {
    
}
