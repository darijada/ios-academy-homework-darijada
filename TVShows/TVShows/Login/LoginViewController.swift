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
    private var tapped = false
    private var numberOfClicksOnCheckMark = 0
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let email = UserDefaults.standard.value(forKey: "email") as? String,
            let password = UserDefaults.standard.value(forKey: "password") as? String
        else { return }
        
        emailTextField.text = email
        passwordTextField.text = password
        logInButtonActionHandler()
        
    }
    
    private func loginFailureAlert(){
        let alert = UIAlertController(title: "Login failure alert", message: "Incorrect Email or Password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
  
    @IBAction func rememberMeTapped(_ sender: Any) {
        self.numberOfClicksOnCheckMark += 1
        
        if (numberOfClicksOnCheckMark % 2 != 0){
            self.tapped = true
            checkmarkButton.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
            print("Remember me!")
        }
        else{
            self.tapped = false
            checkmarkButton.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
            print("Don't remember me!")
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func logInButtonActionHandler() {
        guard let userEmail = emailTextField.text else { return }
        guard let userPassword = passwordTextField.text else { return }
        loginUser(email: userEmail, password: userPassword)
   }

    @IBAction private func createAccountButtonActionHandler() {
        guard let userEmail = emailTextField.text else { return }
        guard let userPassword = passwordTextField.text else { return }
        createUserAccount(email: userEmail, password: userPassword)    }
}

    // MARK: - Register + automatic JSON parsing

private extension LoginViewController {
    
    func createUserAccount(email: String, password: String) {
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
                   let storyboard = UIStoryboard(name: "Home", bundle: nil)
                   let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController") as! HomeViewController
                   self.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Email or Password field is required!")
                }
        }
    }
}

    // MARK: - Login + automatic JSON parsing

private extension LoginViewController {
    
    func loginUser(email: String, password: String) {
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
            .responseDecodableObject(keyPath: "data", completionHandler: { [weak self] (response: DataResponse<LoginData>) in
                switch response.result {
                case .success(let loginData):
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController") as! HomeViewController
                    
                    viewController.token = loginData.token
                    
                    if self?.tapped == true {
                        guard let userEmail = self?.emailTextField.text else { return }
                        guard let userPassword = self?.passwordTextField.text else { return }
                        UserDefaults.standard.set(userEmail, forKey: "email")
                        UserDefaults.standard.set(userPassword, forKey: "password")
                    }
                    self?.navigationController?.setViewControllers([viewController], animated: true)
                    SVProgressHUD.showSuccess(withStatus: "Successful login!")
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.logInButton.pulsate()
                    //self?.loginFailureAlert()
                }
                SVProgressHUD.dismiss()
            })
    }
}

extension UIButton{
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}
