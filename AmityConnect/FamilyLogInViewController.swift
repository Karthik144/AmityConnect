//
//  FamilyLogInViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/30/21.
//

import UIKit
import FirebaseAuth
import Firebase

class FamilyLogInViewController: UITableViewController {

    // IB Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    @IBOutlet weak var centerIDTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()

    }


    func setUpElements() {

        // Hides the error label
        errorLabel.alpha = 0
    }

    @IBAction func loginButtonPressed(_ sender: Any) {


        // Validate Text Fields

        // Create cleaned version
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = pswdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Sign in the User
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1

            }

            else {

                // Sets UserDefaults to true when the user is logged in
                UserDefaults.standard.set(true, forKey: "isFamilyLoggedIn")

                // Direct the user to the home view controller once logged in
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "FamilyTabBarController")

                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()

            }
        }
    }

}

