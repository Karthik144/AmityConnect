//
//  AddNotesViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import UIKit
import Firebase

class AddNotesViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    
    // Variables
    var notes = [NotesInfo]()
    var name = ""
    private var db = Firestore.firestore()
    private var notesCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        // Creates a reference to the collection of elders
        notesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

    }


    @IBAction func cancelButtonPressed(_ sender: UIButton) {

        // Dismisses the view once the cancel button is pressed
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logButtonPressed(_ sender: UIButton) {

        // Retrieves data from Firestore
        notesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                
                // Iterates through each document (elder) in the collection (center_elders)
                for document in snap.documents {
                    let data = document.data()
                    
                    // Stores specific data points as a variables
                    let elderName = data["name"] as? String ?? ""
                    let documentId = document.documentID
                    
                    // Checks if the name that is passed through is equal to the document name
                    if self.name == elderName{

                        // Creates a new document in the notes collection
                        let newDocument = self.notesCollectionRef.document(documentId).collection("notes").document()

                        // Sets new document with the data that has been inputted into the textview and textfield
                        newDocument.setData(["note":self.noteBodyTextView.text ?? "","title": self.noteTitleTextField.text ?? ""])
                        
                    }
                    
                }
                
            }


        }

        // Dismisses the view once the log button is pressed
        dismiss(animated: true, completion: nil)
    }
    
    

}
