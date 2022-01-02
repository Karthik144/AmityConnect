//
//  FamilyProfileTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/31/21.
//

import UIKit

class FamilyProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isFamilyLoggedIn")

        self.navigationController?.popToRootViewController(animated: true)

    }


}
