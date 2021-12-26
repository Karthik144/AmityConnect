//
//  ProfileTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}
