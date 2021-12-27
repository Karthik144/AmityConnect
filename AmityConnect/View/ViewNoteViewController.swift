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
        
        notesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
        
        noteTitleTextField.isUserInteractionEnabled = false
        noteBodyTextField.isUserInteractionEnabled = false
        
        loadData()
    }
    
    
    func loadData(){
        
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
                    
                    if self.name == elderName{
                        self.notesCollectionRef.document(originalDocumentId).collection("notes").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (elder) in the collection (center_elders)
                                for noteDocument in snap.documents {
                                    let data = noteDocument.data()

                                    // Stores specific data points as a variables
                                    let note = data["note"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let noteDocumentId = noteDocument.documentID
                                    
                                    if noteDocumentId == self.id {
                                        
                                        let newNote = NotesInfo(id: noteDocumentId, title: title, note: note)
                                        
                                        self.notes.append(newNote)
                                        
                                        self.inputData()
                                        
                                    }
                                         
                        }
                                
                    }
                }
            }


        }

        
        
    }
            
        }
        
    } //End
    
    func inputData() {
        
        noteTitleTextField.text = notes[0].title
        noteBodyTextField.text = notes[0].note
    }
    
    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        buttonCounter += 1
        
        if buttonCounter % 2 != 0{
            editBarButton.title = "Save"
            
            noteTitleTextField.isUserInteractionEnabled = true
            noteBodyTextField.isUserInteractionEnabled = true
            
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
                                        let data = noteDocument.data()

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
                
            }//End
            
            
            
            
            
            
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
                                    let data = noteDocument.data()

                                    // Stores specific data points as a variables
                                    let noteDocumentId = noteDocument.documentID
                                    
                                    if noteDocumentId == self.id {
                                        
                                        self.notesCollectionRef.document(originalDocumentId).collection("notes").document(noteDocumentId).delete()
                                   
                                    
    
                                    }
                                         
                        }
                                
                    }
                }
            }


        }

        
        
    }
            
        }
        
        //let vc = storyboard?.instantiateViewController(withIdentifier: "NotesVC") as? NotesTableViewController
        
        //navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
        
    }
    

