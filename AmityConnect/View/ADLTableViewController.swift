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
    var adls = [ADLInfo]()
    var dates = [String]()
    private var db = Firestore.firestore()
    private var adlsCollectionRef:CollectionReference!


    override func viewDidLoad() {
        super.viewDidLoad()

        adlsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        loadData()

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
                        print("NAME STATEMENT")
                        self.adlsCollectionRef.document(originalDocumentId).collection("ADLS").getDocuments { (snapshot, error) in

                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                print("HERE")

                                // Iterates through each document (elder) in the collection (center_elders)
                                for adlDocument in snap.documents {
                                    print("ADL DOCUMENT")
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

                                    let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3, activity_4: activity4, activity_5: activity5, activity_6: activity6)

                                    self.adls.append(newAdl)

                                    print(activity1)


                                    if activity1 != "" && activity2 != "" && activity3 != "" && activity4 != "" && activity5 != "" && activity6 != ""{

                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3, activity_4: activity4, activity_5: activity5, activity_6: activity6)
                                        self.adls.append(newAdl)

                                    }

                                    if activity1 != "" && activity2 != "" && activity3 != "" && activity4 != "" && activity5 != ""{

                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3, activity_4: activity4, activity_5: activity5)
                                        self.adls.append(newAdl)

                                    }

                                    if activity1 != "" && activity2 != "" && activity3 != "" && activity4 != ""{

                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3, activity_4: activity4)
                                        self.adls.append(newAdl)

                                    }

                                    if activity1 != "" && activity2 != "" && activity3 != ""{

                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2, activity_3: activity3)
                                        self.adls.append(newAdl)

                                    }

                                    if activity1 != "" && activity2 != ""{

                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1, activity_2: activity2)
                                        self.adls.append(newAdl)

                                    }

                                    if activity1 != ""{
                                        print("ACTIVITY")


                                        let newAdl = ADLInfo(id: adlDocumentId, type: type, date: date, activity_1: activity1)
                                        self.adls.append(newAdl)

                                    }

                                    for one in self.adls {
                                        print("ENTERED1")

                                        for second in self.adls{

                                            for third in self.adls{

                                                for fourth in self.adls{

                                                    if one.date == second.date {
                                                        print("ENTERED")
                                                        if second.date == third.date{
                                                            if third.date == fourth.date{
                                                                self.dates.append(one.date)
                                                            }
                                                        }
                                                    }

                                                }
                                            }
                                        }

                                    }

                        }

                    }
                }
            }


        }



    }

        }



    }

    @IBAction func newADLButtonPressed(_ sender: UIButton) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "IndependentView") as? IndependentTableViewController

        vc?.name = name

        self.navigationController?.pushViewController(vc!, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Creates an adlDateCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "adlDateCell", for: indexPath) as! adlDateCell

        // Sets the cell label to the type of activity
        cell.cellLabel.text = dates[indexPath.row]

        return cell

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
