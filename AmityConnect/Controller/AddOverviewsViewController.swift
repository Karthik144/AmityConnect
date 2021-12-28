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
                
                // Iterates through each document (elder) in the collection (center_elders)
                for document in snap.documents {
                    let data = document.data()
                    
                    // Stores specific data points as a variables
                    let elderName = data["name"] as? String ?? ""
                    let documentId = document.documentID
                    
                    
                    if self.name == elderName{
                        
                        let newDocument = self.overviewsCollectionRef.document(documentId).collection("daily_overviews").document()
                        
                        newDocument.setData(["overview":self.overviewBodyTextField.text ?? "","title": self.overviewTitleTextField.text ?? ""])
                        
                    }
                    
                }
                
            }
                
        
        }
        
        dismiss(animated: true, completion: nil)
    }
    


}
