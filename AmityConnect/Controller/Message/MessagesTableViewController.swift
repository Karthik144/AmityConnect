//
//  MessagesTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 1/1/22.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {


    // Variables
    private var profiles = [ProfileInfo]()
    private var db = Firestore.firestore()
    private var profilesCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        // Sets the title of the navigation view controller
        self.title = "Messages"

        // Creates a reference to all the caretakers stores in Firestore
        profilesCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("caretakers")

        // Calls the function to retrieve data from Firestore
        loadData()
    }

    private func loadData() {

        // Retrieves data from Firestore
        profilesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }

                // Iterates through each document (caretaker) in the collection (caretakers)
                for document in snap.documents {
                    let data = document.data()

                    // Stores specific data points as a variables
                    let fullName = data["full_name"] as? String ?? ""
                    let position = data["position"] as? String ?? ""
                    let documentId = document.documentID


                    // Creates an ProfileInfo Structure with the retrieved data from each document
                    let newProfile = ProfileInfo(full_name: fullName, id: documentId, position: position)

                    // Adds each created ProfileInfo structure to the profiles list
                    self.profiles.append(newProfile)

                }

                // Reloads data in the tableview
                self.tableView.reloadData()
            }
        }




    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profiles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "messageOverviewCell", for: indexPath) as? MessageOverviewCell

        // Configure the cell...
        cell?.nameLabel.text = profiles[indexPath.row].full_name
        cell?.positionName.text = profiles[indexPath.row].position

        return cell!
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // Sets the height of each cell
//        return 70
//    }


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
