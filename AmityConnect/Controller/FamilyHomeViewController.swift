//
//  FamilyHomeViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/31/21.
//

import UIKit
import Firebase

class FamilyHomeViewController: UITableViewController {


    // Variables
    private var elders = [ElderOverview]()
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!
    private var familiesCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Creates a collection reference to the center's elders
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Creates a collection reference to the center's family members
        familiesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("family_members")

        // Calls the load data function to retrieve data from backend
        loadData()
    }


    func loadData(){

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

                                    self.elders.append(newElder)
                                }

                                // Reloads data in the table view
                                self.tableView.reloadData()
                            }

                        }
                    }


                }


            }
        }



    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elderCell = tableView.dequeueReusableCell(withIdentifier: "elderCell", for: indexPath) as? elderCell

        elderCell?.configureCell(elderOverview: elders[indexPath.row])

        return elderCell!

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "familyElderSpecificView") as? familyElderSpecificTableViewController

        vc?.name = (elders[indexPath.row]).name
        vc?.age = (elders[indexPath.row]).age
        vc?.condition = (elders[indexPath.row]).condition
        vc?.gender = (elders[indexPath.row]).gender

        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}


