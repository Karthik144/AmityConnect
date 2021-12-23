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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    let db = Firestore.firestore()
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        
        //db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders").document("6Hi9FbYWZr6c0reCarng").setData(["age": ageTextField.text ?? "", "condition": healthTextField.text ?? "none", "name": nameTextField.text ?? "", "caretaker": careTakerTextField.text ?? "", "family_email": familyEmailTextField.text ?? ""])
        
        let newDocument = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders").document()
        
        newDocument.setData(["age": ageTextField.text ?? "", "condition": healthTextField.text ?? "none", "name": nameTextField.text ?? "", "caretaker": careTakerTextField.text ?? "", "family_email": familyEmailTextField.text ?? ""])
        
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    
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
