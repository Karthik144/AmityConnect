//
//  DoesNotDoTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/28/21.
//

import UIKit
import Firebase

class DoesNotDoTableViewController: UITableViewController {

    //Variables
    var name = ""
    var activites = ["Oral Care", "Bathing", "Dressing", "Stairs", "Brushing", "Walking"]
    var selectedList = [String]()
    var finalSelectedList = [String]()
    private var db = Firestore.firestore()
    private var ADLCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets navigation bar title
        self.title = "Does Not Do"

        // Creates a reference to a center's elders
        ADLCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Sets the number of rows equal to the number of items in the activities list
        return activites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Creates a DoesNotDoSelectionCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoesNotDoSelectionCell", for: indexPath) as! DoesNotDoSelectionCell

        // Sets the cell label to the type of activity
        cell.cellLabel.text = activites[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Creates a new cell reference to the selected cell
        let cell = tableView.cellForRow(at: indexPath)

        // If cell already has a checkmark and is selected again, remove it
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {

            // Add a checkmark if the user selects it
            cell?.accessoryType = .checkmark
        }

        // Append all items selected into the list
        selectedList.append(activites[indexPath.row])

        // Check for duplicates and add to the new list
        for each in selectedList{
            if !finalSelectedList.contains(each){
                finalSelectedList.append(each)
            }
        }

    }


    @IBAction func nextButtonPressed(_ sender: UIButton) {

        // Gets the current date and time
        let currentDateTime = Date()


        // Initializes the date formatter and sets the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        // Gets the date and time from the date object
        let dateTimeString = formatter.string(from: currentDateTime)


        // Retrieves data from Firestore
        ADLCollectionRef.getDocuments { [self] (snapshot, error) in
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

                    // Checks if the name is in the document
                    if self.name == elderName{

                        let newDocument = self.ADLCollectionRef.document(documentId).collection("ADLs").document()

                        // Add this if no activities are selected
                        if finalSelectedList.count <= 0{

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": "none"])
                        }

                        // Add this is only one activity is selected
                        if finalSelectedList.count == 1{

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0]])
                        }

                        // Add this if two activities are selected
                        if finalSelectedList.count == 2 {

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0], "activity_2": finalSelectedList[1]])

                        }

                        // Add this if three activities are selected
                        if finalSelectedList.count == 3 {

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0], "activity_2": finalSelectedList[1], "activity_3":finalSelectedList[2]])

                        }

                        // Add this if four activities are selected
                        if finalSelectedList.count == 4 {

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0], "activity_2": finalSelectedList[1], "activity_3":finalSelectedList[2],"activity_4":finalSelectedList[3]])

                        }

                        // Add this if five activities are selected
                        if finalSelectedList.count == 5 {

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0], "activity_2": finalSelectedList[1], "activity_3":finalSelectedList[2],"activity_4":finalSelectedList[3], "activity_5":finalSelectedList[4]])

                        }

                        // Add this if 6 activities are selected
                        if finalSelectedList.count == 6 {

                            newDocument.setData(["type":"Does Not Do", "date":dateTimeString, "activity_1": finalSelectedList[0], "activity_2": finalSelectedList[1], "activity_3":finalSelectedList[2],"activity_4":finalSelectedList[3], "activity_5":finalSelectedList[4], "activity_6":finalSelectedList[5]])

                        }

                    }

                }

            }




    }

        // Pushes the next screen once data is saved
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")

        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()

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
