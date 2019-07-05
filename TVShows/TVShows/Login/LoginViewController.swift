//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 4/14/1398 AP.
//  Copyright © 1398 Infinum Academy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    // numer of clicks stored in counter
    
    var counter = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myLabel.text = String(counter)
        
    }
    
    @IBAction func myButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        counter += 1
        
        myLabel.text = String(counter)
    }
    
    
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
