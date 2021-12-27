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
    @IBOutlet weak var elderImage: UIImageView!
    
    // Variables
    private var db = Firestore.firestore()
    var elders = [ElderOverview]()
    let rightBarDropDown = DropDown()
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
        
        if gender == "Male"{
            elderImage.image = UIImage(named: "elderMan")
        } else if gender == "Female"{
            elderImage.image = UIImage(named: "elderWoman")
        }
        
        rightBarDropDown.anchorView = elderAssessButton
        rightBarDropDown.dataSource = ["ADL", "Daily Overview", "Notes"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
            
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
        
        
        rightBarDropDown.selectionAction = { (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
            
            
            if index == 2{
    
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotesVC") as? NotesTableViewController
                vc?.name = self.name
                self.navigationController?.pushViewController(vc!, animated: true)
                         
            }
            
            if index == 1{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OverviewVC") as? OverviewTableViewController
                vc?.name = self.name
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }

        rightBarDropDown.width = 130
        rightBarDropDown.cornerRadius = 10
        rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
        rightBarDropDown.show()
        
    }
    
    
}
    

