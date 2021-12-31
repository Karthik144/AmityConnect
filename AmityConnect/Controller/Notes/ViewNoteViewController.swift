//
//  ViewNoteViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import UIKit
import Firebase

class ViewNoteViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // Variables
    var notes = [NotesInfo]()
    var name = ""
    var id = ""
    private var db = Firestore.firestore()
    private var notesCollectionRef:CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Creates a reference to the collection (center_elders)
        notesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Does not allow the user to edit any text (becasue user has not selected edit yet)
        noteTitleTextField.isUserInteractionEnabled = false
        noteBodyTextField.isUserInteractionEnabled = false

        // Calls the loadData function
        loadData()
    }
    
    
    func loadData(){
        
        // Retrieve data from Firestore
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

                    let originalDocumentId = document.documentID

                    // If the name of the document is equal to the eldername that is passed through, enter into its notes collection
                    if self.name == elderName{
                        self.notesCollectionRef.document(originalDocumentId).collection("notes").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (note) in the collection ("notes")
                                for noteDocument in snap.documents {
                                    let data = noteDocument.data()

                                    // Stores specific data points as a variables
                                    let note = data["note"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let noteDocumentId = noteDocument.documentID

                                    // Checks to see if it is the right ID
                                    if noteDocumentId == self.id {

                                        // Creates a newNote using the NotesInfo Model
                                        let newNote = NotesInfo(id: noteDocumentId, title: title, note: note)

                                        // Appends the newNotes into the notes list
                                        self.notes.append(newNote)

                                        // Calls the input data function
                                        self.inputData()
                                        
                                    }

                                }
                                
                            }
                        }
                    }


                }



            }
            
        }
        
    }
    
    func inputData() {
        // Sets the textfield with data
        noteTitleTextField.text = notes[0].title
        noteBodyTextField.text = notes[0].note
    }

    // Creates an accumulator variable
    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        // Adds to the counter each time the button is pressed
        buttonCounter += 1

        // If button is pressed an odd number of times, then allow use to edit
        if buttonCounter % 2 != 0{
            editBarButton.title = "Save"
            
            noteTitleTextField.isUserInteractionEnabled = true
            noteBodyTextField.isUserInteractionEnabled = true


            // Otherwise do not allow the user to edit
        } else {
            
            editBarButton.title = "Edit"
            
            noteTitleTextField.isUserInteractionEnabled = false
            noteBodyTextField.isUserInteractionEnabled = false
            
            //Retrieve data from Firestore
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

                        let originalDocumentId = document.documentID

                        // Checks if the name that is passed through is equal to the document name
                        if self.name == elderName{
                            self.notesCollectionRef.document(originalDocumentId).collection("notes").getDocuments { [self] (snapshot, error) in
                                
                                if let error = error {
                                    print ("Error fetching documents: \(error)")
                                } else {
                                    guard let snap = snapshot else {
                                        return
                                    }

                                    // Iterates through each note document in the collection (notes)
                                    for noteDocument in snap.documents {

                                        // Stores specific data points as a variables
                                        let noteDocumentId = noteDocument.documentID
                                        
                                        if noteDocumentId == self.id {
                                            
                                            self.notesCollectionRef.document(originalDocumentId).collection("notes").document(noteDocumentId).setData(["note": self.noteBodyTextField.text ?? "", "title":self.noteTitleTextField.text ?? ""])

                                            
                                        }

                                    }
                                    
                                }
                            }
                        }


                    }



                }
                
            }
            
            
            
            
            
            
        }
        
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        //Retrieve data from Firestore
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

                    let originalDocumentId = document.documentID

                    // Checks if the name that is passed through is equal to the document name
                    if self.name == elderName{
                        self.notesCollectionRef.document(originalDocumentId).collection("notes").getDocuments { [self] (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each note document in the collection (notes)
                                for noteDocument in snap.documents {

                                    // Stores specific data points as a variables
                                    let noteDocumentId = noteDocument.documentID
                                    
                                    if noteDocumentId == self.id {

                                        // Deletes the note that has been selected
                                        self.notesCollectionRef.document(originalDocumentId).collection("notes").document(noteDocumentId).delete()



                                    }

                                }
                                
                            }
                        }
                    }


                }



            }
            
        }

    }
    
    
    

}


