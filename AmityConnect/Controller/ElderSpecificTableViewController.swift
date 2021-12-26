//
//  ElderSpecificTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/23/21.
//

import UIKit
import Firebase
import DropDown

class ElderSpecificTableViewController: UITableViewController {
    
    
    // IB Outlets
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var elderAssessButton: UIBarButtonItem!
        
    // Variables
    private var db = Firestore.firestore()
    var elders = [ElderOverview]()
    private var eldersCollectionRef: CollectionReference!
    var name = ""
    var age = ""
    var condition = ""
    var gender = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageTextField.text = age
        conditionTextField.text = condition
        genderTextField.text = gender
        self.title = name
        
        ageTextField.isUserInteractionEnabled = false
        conditionTextField.isUserInteractionEnabled = false
        genderTextField.isUserInteractionEnabled = false
        
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
     
    }
    
    
    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        buttonCounter += 1
        
        if buttonCounter % 2 != 0 {
            
            barButton.title = "Save"
            
            ageTextField.isUserInteractionEnabled = true
            conditionTextField.isUserInteractionEnabled = true
            genderTextField.isUserInteractionEnabled = true
            
        } else {
            barButton.title = "Edit"
            
            ageTextField.isUserInteractionEnabled = false
            conditionTextField.isUserInteractionEnabled = false
            genderTextField.isUserInteractionEnabled = false
            
            
            eldersCollectionRef.getDocuments { [self] (snapshot, error) in
                if let error = error {
                    print ("Error fetching documents: \(error)")
                    } else {
                        guard let snap = snapshot else {
                            return
                        }

                        // Iterates through each document (elder) in the collection (center_elders)
                        for document in snap.documents {
                            let data = document.data()
                            
                            // Sets data from Firebase as a variable
                            let caretaker = data["caretaker"] as? String ?? ""
                            let familyEmail = data["family_email"] as? String ?? ""
                            let elderName = data["name"] as? String ?? ""
                            
                            // If selected elder name is equal to the elderName in the document, upload edited data to the document 
                            if name == elderName {
                                    eldersCollectionRef.document(document.documentID).setData(["age": ageTextField.text ?? "", "caretaker":caretaker, "condition":conditionTextField.text ?? "", "family_email":familyEmail, "gender":genderTextField.text ?? "", "name":elderName])
                                }
                            
                      
                            }

                        }

                    }
            } //Ends
        }

    
    @IBAction func elderAssessButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}
    

