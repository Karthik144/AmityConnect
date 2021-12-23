//
//  HomeViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/19/21.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Variables
    var elders = [ElderOverview]()
    var elderNames : [String]!
    var filteredElders : [String]!
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!
    var searching = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        searchBar.delegate = self
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
        
        elderNames = []
        for elder in elders{
            elderNames.append(elder.name)
        }
        
        filteredElders = elderNames

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Retrieves data from Firestore
        eldersCollectionRef.getDocuments { (snapshot, error) in
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
                    let name = data["name"] as? String ?? ""
                    let documentId = document.documentID
                    
                    // Creates an ElderOverview Structure with the retrieved data from each document
                    let newElderOverview = ElderOverview(id: documentId, age: age, caretaker: caretaker, condition: condition, family_email: familyEmail, name: name)
                    
                    // Adds each created ElderOverview structure to the elders list
                    self.elders.append(newElderOverview)
                    
                }
                
                // Reloads data in the tableview
                self.tableView.reloadData()
            }
                
        
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            return filteredElders.count
            
        } else {
            
            // Sets the number of rows as the number of ElderOverview items in the list
            return elders.count
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let elderCell = tableView.dequeueReusableCell(withIdentifier: "elderCell", for: indexPath) as? elderCell
        
        if searching {
            elderCell?.textLabel?.text = filteredElders[indexPath.row]
            return elderCell!

        } else {
            elderCell?.configureCell(elderOverview: elders[indexPath.row])
            return elderCell!

        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredElders = []
        for name in elderNames{
            if name.lowercased().contains(searchText.lowercased()){
                filteredElders.append(name)
            }
        }
        
        searching = true
        print("entered")
        //self.tableView.reloadData()
    }
}
    

