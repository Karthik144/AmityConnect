//
//  SignUpViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/19/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UITableViewController {
    
    // IB Outlets
   
   
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    @IBOutlet weak var centerIdTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide the error labels
        errorLabel.alpha = 0
        
    }
    
    
    // Check fields and validate that data is corerctly formatted
    func validateFields() -> String? {
        
        // Check that all text fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  positionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || centerIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            
        }
        
        return nil
        
    }

    
    @IBAction func signUpPressed(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // There is something wrong with the fields
            showErrorMessage(error!)
            
        }
    

        else {
    
            
            // Create cleaned versions of the data
            let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          
            let position = positionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = pswdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let centerId = centerIdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            
            // Create the user (if there is no error)
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // Check for errors
                if error != nil {
                    
                    // There was an error
                    self.showErrorMessage("Error creating user")
                    
                }
                
                else {
                    
                    // User was created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("caretakers").addDocument(data: ["full_name":fullName, "email":email,"position":position,"center_id": centerId, "id":Auth.auth().currentUser!.uid]) { (error) in
                        
                        if error != nil {
                            
                            //Show error message
                            self.showErrorMessage("Error saving user data")
                        }
                    }
                    
                    
                    // Transtion to the home screen
                    self.transitionToHome()
                }
            }
        }
        
        
    }
    
    func showErrorMessage(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Transition to the home screen
    func transitionToHome() {
        
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}
