//
//  NotesTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import UIKit
import Firebase

class NotesTableViewController: UITableViewController {
    
    
    // Variables
    var notes = [NotesInfo]()
    var name = ""
    private var db = Firestore.firestore()
    private var notesCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates a reference to center_elders collection
        notesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Loads data once view loads
        loadData()
    }

    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {

        // Presents a pop up vc (AddNotesVC) when the bar button item is pressed
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesViewController else {return}

        //Passes the name variable over when it presents the controller
        nvc.name = name
        navigationController?.present(nvc, animated: true, completion: nil)
        
        
    }
    
    // Creates a global variable for document id that can be used throughout
    var originalDocumentId = ""

    func loadData() {
        
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
                
                    let originalDocumentId = document.documentID

                    // If elder name is the name that was passed to this vc, then add its note data
                    if self.name == elderName{
                        self.notesCollectionRef.document(originalDocumentId).collection("notes").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (note) in the collection (notes)
                                for noteDocument in snap.documents {
                                    let data = noteDocument.data()

                                    // Stores specific data points as a variables
                                    let note = data["note"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let noteDocumentId = noteDocument.documentID

                                    // Creates a new note with the NotesInfo model and adds the stored data into it
                                    let newNote = NotesInfo(id: noteDocumentId, title: title, note: note)

                                    // Appends the newNotes to the list of NotesInfo models
                                    self.notes.append(newNote)
                        }

                                // Reloads table view
                                self.tableView.reloadData()

                    }
                }
            }


        }

        
        
    }
            
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Sets the number of rows equal to the number of items in the notes list
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? noteCell

        // Configures the cell by calling the configureCell function that sets the text label
        noteCell?.configureCell(notesInfo:notes[indexPath.row])

        return noteCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Pushes the ViewNoteVC when a specific notes cell is selected
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewNoteVC") as? ViewNoteViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        vc?.name = name
        vc?.id = notes[indexPath.row].id
    }

    
    // Override to support editing the table view.
    // CURRENTLY IS NOT USED BECAUSE IT DOES NOT WORK 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Retrieves the document id of the note that is selected
            let newDocumentId = notes[indexPath.row].id
            print(newDocumentId)

            // Deletes the note that is selected in the Firestore database
            notesCollectionRef.document(originalDocumentId).collection("notes").document(newDocumentId).delete()
            
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
}
