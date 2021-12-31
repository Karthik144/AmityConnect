//
//  AddOverviewsViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import UIKit
import Firebase

class AddOverviewsViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var overviewTitleTextField: UITextField!
    @IBOutlet weak var overviewBodyTextField: UITextView!
    
    
    // Variables
    var overviews = [OverviewInfo]()
    var name = ""
    private var db = Firestore.firestore()
    private var overviewsCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Creates a reference to the collection of elders
        overviewsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
    }
    
    
    @IBAction func logButtonPressed(_ sender: UIButton) {
        
        
        // Retrieves data from Firestore
        overviewsCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                
                // Iterates through each document (overview) in the collection (overviews)
                for document in snap.documents {
                    let data = document.data()
                    
                    // Stores specific data points as a variables
                    let elderName = data["name"] as? String ?? ""
                    let documentId = document.documentID
                    
                    
                    // Checks if the name that is passed through is equal to the document name
                    if self.name == elderName{
                        
                        // Creates a new document in the overviews collection
                        let newDocument = self.overviewsCollectionRef.document(documentId).collection("daily_overviews").document()
                        
                        // Sets new document with the data that has been inputted into the textview and textfield
                        newDocument.setData(["overview":self.overviewBodyTextField.text ?? "","title": self.overviewTitleTextField.text ?? ""])
                        
                    }
                    
                }
                
            }
            
            
        }
        
        // Dismisses the view once the log button is pressed
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
