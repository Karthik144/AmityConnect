//
//  AddElderViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/21/21.
//

import UIKit
import Firebase

class AddElderViewController: UITableViewController {
    
    // IB Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var healthTextField: UITextField!
    @IBOutlet weak var careTakerTextField: UITextField!
    @IBOutlet weak var familyEmailTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    // Variables
    var genderText = "Male"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            genderText = "Male"
            
        } else {
            genderText = "Female"
            
        }
        
    }
    
    let db = Firestore.firestore()
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let newDocument = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders").document()
        
        newDocument.setData(["age": ageTextField.text ?? "", "condition": healthTextField.text ?? "none", "name": nameTextField.text ?? "", "caretaker": careTakerTextField.text ?? "",
                             "gender":genderText ,"family_email": familyEmailTextField.text ?? ""])
        
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {

        // Dismisses the view once the log button is pressed
        dismiss(animated: true, completion: nil)
    }

    
}
