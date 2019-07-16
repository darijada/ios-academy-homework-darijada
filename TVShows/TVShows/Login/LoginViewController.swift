//
//  ViewController.swift
//  TVShows
//
//  Created by Infinum on 4/13/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var checkmarkButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    private var _infoLabel: String = "Unknown"
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction private func logInButtonActionHandler() {
        _loginUserWith(email: emailTextField.text!, password: passwordTextField.text!)
    }

    @IBAction private func createAccountButtonActionHandler() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewController, animated: true)
        _alamofireCodableRegisterUserWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func loginFailureAlert(){
        let alert = UIAlertController(title: "Login failure alert", message: "Incorrect Email or Password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

    // MARK: - Register + automatic JSON parsing

private extension LoginViewController {
    
    func _alamofireCodableRegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                   print("Success: \(user)")
                   SVProgressHUD.showSuccess(withStatus: "User registered!")
                    
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

    // MARK: - Login + automatic JSON parsing

private extension LoginViewController {
    
    func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let response):
                    self?._infoLabel = "Success: \(response)"
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController")
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    SVProgressHUD.showSuccess(withStatus: "Successful login!")
                case .failure(let error):
                    self?._infoLabel = "API failure: \(error)"
                    SVProgressHUD.dismiss()
                    self?.loginFailureAlert()
                }
        }
    }
}
