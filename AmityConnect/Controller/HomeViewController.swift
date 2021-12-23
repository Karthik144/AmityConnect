//
//  HomeViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/19/21.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    // Variables
    var elders = [ElderOverview]()
    var filteredElders = [] as [String]
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!
    var searching = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eldersCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                for document in snap.documents {
                    let data = document.data()
                    
                    let age = data["age"] as? String ?? ""
                    let caretaker = data["caretaker"] as? String ?? ""
                    let condition = data["condition"] as? String ?? ""
                    let familyEmail = data["family_email"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let documentId = document.documentID
                    
                    let newElderOverview = ElderOverview(id: documentId, age: age, caretaker: caretaker, condition: condition, family_email: familyEmail, name: name)
                    
                    self.elders.append(newElderOverview)
                    
                }
                
                self.tableView.reloadData()
            }
                
        
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            return filteredElders.count
            
        } else {
            
            return elders.count
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if let elderCell = tableView.dequeueReusableCell(withIdentifier: "elderCell", for: indexPath) as? elderCell{
//            elderCell.configureCell(elderOverview: elders[indexPath.row])
//            return elderCell
//        } else {
//            return UITableViewCell()
//        }
        
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
        
        
        for elder in elders {
                    
            let name = elder.name.lowercased()
            
            if name.contains(searchText.lowercased()){
                filteredElders.append(name)
            }
        }
        
        searching = true
        tableView.reloadData()

        
    }
    

    

}
    

