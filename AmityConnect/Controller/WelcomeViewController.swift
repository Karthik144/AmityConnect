//
//  WelcomeViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/19/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            
            self.navigationController?.pushViewController(homeViewController, animated: false)
            
        }
    }
    


}

