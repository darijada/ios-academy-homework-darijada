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

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var checkmarkButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction private func logInButtonActionHandler() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func createAccountButtonActionHandler() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController( withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
}
