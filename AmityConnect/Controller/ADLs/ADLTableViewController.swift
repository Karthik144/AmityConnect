//
//  ADLTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import UIKit
import Firebase

class ADLTableViewController: UITableViewController {


    // Variables
    var name = ""
    var currentDate = ""
    var adls = [ADLInfo]()
    var dates = [String]()
    private var db = Firestore.firestore()
    private var adlsCollectionRef:CollectionReference!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates a reference to center_elders collection
        adlsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Loads data once view loads
        loadData()

        print(dates)
        print(adls.count)

    }

    func loadData() {

        //Retrieve data from Firestore
        adlsCollectionRef.getDocuments { (snapshot, error) in
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
                        self.adlsCollectionRef.document(originalDocumentId).collection("ADLs").getDocuments { [self] (snapshot, error) in

                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }


                                // Iterates through each document (adl) in the collection (ADLs)
                                for adlDocument in snap.documents {
                                    let data = adlDocument.data()

                                    // Stores specific data points as a variables
                                    let type = data["type"] as? String ?? ""
                                    let date = data["date"] as? String ?? ""
                                    let activity1 = data["activity_1"] as? String ?? ""
                                    let activity2 = data["activity_2"] as? String ?? ""
                                    let activity3 = data["activity_3"] as? String ?? ""
                                    let activity4 = data["activity_4"] as? String ?? ""
                                    let activity5 = data["activity_5"] as? String ?? ""
                                    let activity6 = data["activity_6"] as? String ?? ""
                                    let adlDocumentId = adlDocument.documentID

                                    // Creates a new adl with the ADLInfo model and adds the stored data into it
                                    let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3, activity_4: activity4, activity_5: activity5, activity_6: activity6)

                                    // Appends the newADL to the list of ADLInfo models
                                    self.adls.append(newAdl)

                                }

                                // Creates an accumulator variable
                                var count = 0

                                // Adds each adl to a list of dates
                                for each in self.adls{
                                    count += 1
                                    print(currentDate)
                                    if each.date != currentDate && count == 1{
                                        currentDate = each.date
                                    }

                                    if each.date == currentDate && count == 2{
                                        currentDate = each.date
                                    }

                                    if each.date == currentDate && count == 3{
                                        currentDate = each.date
                                    }

                                    if each.date == currentDate && count == 4{
                                        currentDate = each.date
                                        self.dates.append(currentDate)
                                    } else {
                                        print("Dates did not match")
                                    }

                                }

                                // Reload data in table view
                                self.tableView.reloadData()


                            }
                        }
                    }


                }



            }

        }



    }

    @IBAction func newADLButtonPressed(_ sender: UIButton) {

        // Presents a pop up vc (IndependentView) when the bar button item is pressed
        let vc = storyboard?.instantiateViewController(withIdentifier: "IndependentView") as? IndependentTableViewController

        //Passes the name variable over when it presents the controller
        vc?.name = name
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Sets the number of rqws equal to the number of items in the dates list
        return dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Creates an adlDateCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "adlDateCell", for: indexPath) as! adlDateCell

        // Sets the cell label to the type of activity
        cell.cellLabel.text = dates[indexPath.row]

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Pushes the ADLSpecificView when a specific notes cell is selected
        let vc = storyboard?.instantiateViewController(withIdentifier: "ADLSpecificView") as? SpecificADLTableViewController

        vc?.name = name
        vc?.currentDate = currentDate

        navigationController?.pushViewController(vc!, animated: true)

    }

}
