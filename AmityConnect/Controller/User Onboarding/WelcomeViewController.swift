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
        
        // Checks if the user has already logged in (via data saved in UserDefaults)
        // If user is already logged, the user is directed to the home page
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            
            self.navigationController?.pushViewController(homeViewController, animated: false)
            
        }

        else if UserDefaults.standard.bool(forKey: "isFamilyLoggedIn") == true {

            let familyHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHomeVC") as! FamilyHomeViewController

            self.navigationController?.pushViewController(familyHomeVC, animated: false)

        }

    }
}
    
    
    


