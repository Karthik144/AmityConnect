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
        
        notesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadData()
    }

    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
        
        
        //let vc = storyboard?.instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesViewController
        //vc?.name = name
        //navigationController?.pushViewController(vc!, animated: true)
        
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesViewController else {return}
        nvc.name = name
        navigationController?.present(nvc, animated: true, completion: nil)
        
        
    }
    
    
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
                    let age = data["age"] as? String ?? ""
                    let caretaker = data["caretaker"] as? String ?? ""
                    let condition = data["condition"] as? String ?? ""
                    let familyEmail = data["family_email"] as? String ?? ""
                    let elderName = data["name"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
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
                                    
                                    let newNote = NotesInfo(id: noteDocumentId, title: title, note: note)
                                    
                                    self.notes.append(newNote)
                        }
                                
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
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? noteCell

        // Configure the cell...
        noteCell?.configureCell(notesInfo:notes[indexPath.row])

        return noteCell!
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    
    // Override to support editing the table view.
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

