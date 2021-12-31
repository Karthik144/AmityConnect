//
//  FamilyProfileEldersTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/31/21.
//

import UIKit
import Firebase

class FamilyProfileEldersTableViewController: UITableViewController {

    // Variables
    var elders = [ElderOverview]()
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!
    private var familiesCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Creates a reference to the collection of elders in a center
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Creates a collection reference to the center's family members
        familiesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("family_members")

        // Displays an Edit button in the navigation bar for this view controller
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                    let gender = data["gender"] as? String ?? ""
                    let documentId = document.documentID

                    //Retrieves data from Firestore
                    self.familiesCollectionRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print ("Error fetching documents: \(error)")
                        } else {
                            guard let snap = snapshot else {
                                return
                            }

                            // Iterates through each document (family member) in the collection (family_members)
                            for document in snap.documents {
                                let data = document.data()

                                // Stores specific data points as a variables
                                let email = data["email"] as? String ?? ""

                                if email == familyEmail {

                                    print(familyEmail)


                                    let newElder = ElderOverview(id: documentId, age: age, gender: gender, caretaker: caretaker, condition: condition, family_email: familyEmail, name: name)

                                    // Adds each created ElderOverview structure to the elders list
                                    self.elders.append(newElder)
                                }

                                // Reloads data in the tableview
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
        // Return the number of rows
        return elders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "profileElderCell", for: indexPath) as! profileElderCell

        // Configure the cell
        let name = elders[indexPath.row].name
        cell.elderName.text = name

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {


            // Delete the row from the list as well as the Table View
            elders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)


        }
    }

}

