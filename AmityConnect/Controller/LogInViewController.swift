//
//  LogInViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/19/21.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UITableViewController {


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
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }

    
    
}
