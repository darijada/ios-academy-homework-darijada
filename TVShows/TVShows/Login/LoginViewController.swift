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
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    // numer of clicks stored in counter
    var counter = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        myLabel.text = String(counter)
        
        
        // Activity Indicator View - automatic start when the view appears and stop 3 seconds later
        
        myActivityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.myActivityIndicator.stopAnimating()
        }
        
        
        
    }
    
    
    @IBAction func myButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        counter += 1
        
        myLabel.text = String(counter)
    }
    
    
    @IBAction func startAIV(_ sender: UIButton, forEvent event: UIEvent) {
        
        myActivityIndicator.startAnimating()
    }
    
 
    @IBAction func stopAIV(_ sender: UIButton){
       
        myActivityIndicator.stopAnimating()

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
