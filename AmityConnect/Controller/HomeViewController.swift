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
    private var elders = [ElderOverview]()
    private var filteredElders = [ElderOverview]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!
    private var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        loadData()
    }

    private func loadData(){


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
                    let gender = data["gender"] as? String ?? ""
                    let documentId = document.documentID

                    // Creates an ElderOverview Structure with the retrieved data from each document
                    let newElderOverview = ElderOverview(id: documentId, age: age, gender: gender, caretaker: caretaker, condition: condition, family_email: familyEmail, name: name)

                    // Adds each created ElderOverview structure to the elders list
                    self.elders.append(newElderOverview)

                }

                // Reloads data in the tableview
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? filteredElders.count : elders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elderCell = tableView.dequeueReusableCell(withIdentifier: "elderCell", for: indexPath) as? elderCell

        if searching {
            elderCell?.configureCell(elderOverview: filteredElders[indexPath.row]) //
        } else {
            elderCell?.configureCell(elderOverview: elders[indexPath.row])
        }

        return elderCell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ElderSpecificView") as? ElderSpecificTableViewController

        vc?.name = (elders[indexPath.row]).name
        vc?.age = (elders[indexPath.row]).age
        vc?.condition = (elders[indexPath.row]).condition
        vc?.gender = (elders[indexPath.row]).gender

        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = searchText != ""

        // Filter elders based on name (case insenstive)
        filteredElders = elders
          .filter({ $0.name.lowercased().contains(searchText.lowercased()) })
    }
}

