//
//  PersonalInfoTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/24/21.
//

import UIKit
import Firebase

class PersonalInfoTableViewController: UITableViewController {
    
    // IB Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    @IBOutlet weak var barButton:
        UIBarButtonItem!
    
    // Variables
    private var db = Firestore.firestore()
    var profiles = [ProfileInfo]()
    private var profileCollectionRef: CollectionReference!
    let userID = Auth.auth().currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Crates a references to the collection (caretakers)
        profileCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("caretakers")
        
        loadData()
        
        
        fullNameTextField.isUserInteractionEnabled = false
        positionTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        pswdTextField.isUserInteractionEnabled = false

    }
    
    func loadData() {
        
        profileCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                
                for document in snap.documents {
                    let data = document.data()
                    
                    let uid = data["id"] as? String ?? ""
                    
                    if uid == self.userID {
                        
                        // Sets variables equal to profile properities
                        let fullName = data["full_name"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let position = data["position"] as? String ?? ""
                        let centerId = data["center_id"] as? String ?? ""
                        
                    
                        // Creates an ProfileInfo Structure with the retrieved data from each document
                        let newProfile = ProfileInfo(full_name: fullName, id: uid, email: email, position: position, centerId: centerId)
                        
                        // Adds each created ProfileInfo structure to the profiles list
                        self.profiles.append(newProfile)
                        
                        self.inputData()
                        
                    }
                  
            
                }
            }
        }

    }
    
    func inputData() {
        for profile in profiles {
            if userID == profile.id {
                
                fullNameTextField.text = profile.full_name
                positionTextField.text = profile.position
                emailTextField.text = profile.email
                
            }
        }
    }

    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        
        buttonCounter += 1
        
        
        if buttonCounter % 2 != 0{
            barButton.title = "Save"
            
            fullNameTextField.isUserInteractionEnabled = true
            positionTextField.isUserInteractionEnabled = true
            emailTextField.isUserInteractionEnabled = true
            pswdTextField.isUserInteractionEnabled = true
            
        } else {
            
            barButton.title = "Edit"
            
            fullNameTextField.isUserInteractionEnabled = false
            positionTextField.isUserInteractionEnabled = false
            emailTextField.isUserInteractionEnabled = false
            pswdTextField.isUserInteractionEnabled = false
            
            
            
            profileCollectionRef.getDocuments { [self] (snapshot, error) in
                if let error = error {
                    print ("Error fetching documents: \(error)")
                } else {
                    guard let snap = snapshot else {
                        return
                    }
                    
                    for document in snap.documents {
                        let data = document.data()
                        
                        let uid = data["id"] as? String ?? ""
                        
            
                        if uid == self.userID {
                            
                            let centerId = data["center_id"] as? String ?? ""
                            
                            profileCollectionRef.document(document.documentID).setData(["full_name": fullNameTextField.text ?? "", "position": positionTextField.text ?? "", "email": emailTextField.text ?? "", "id": uid, "center_id": centerId])
                            
                        }
                        
                    }
                
                }
            
            }
            
            
        }
        
      
    }
    
} 

