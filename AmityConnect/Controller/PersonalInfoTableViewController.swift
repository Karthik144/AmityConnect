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
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pswdLabel: UILabel!
    
    // Variables
    private var db = Firestore.firestore()
    var profiles = [ProfileInfo]()
    private var profileCollectionRef: CollectionReference!
    let userID = Auth.auth().currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Crates a references to the collection (caretakers)
        profileCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("caretakers")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                        
                        print(fullName)
                        print(uid)
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
                
                fullNameLabel.text = profile.full_name
                positionLabel.text = profile.position
                emailLabel.text = profile.email
                
            }
        }
    }

    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "editInfo") as? EditPersonalInfoTableViewController
        navigationController?.pushViewController(vc!, animated: false)
        
    }
    
}


class EditPersonalInfoTableViewController: UITableViewController {
    
    
    // IB Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswdTextField: UILabel! // Not connected for now
    
    
    // Variables
    private var db = Firestore.firestore()
    var profiles = [ProfileInfo]()
    private var profileCollectionRef: CollectionReference!
    let userID = Auth.auth().currentUser!.uid
    let email = Auth.auth().currentUser!.email
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("caretakers")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
      
        
        
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "profileInfo") as? PersonalInfoTableViewController
        navigationController?.pushViewController(vc!, animated: false)
        
    }
        
}
