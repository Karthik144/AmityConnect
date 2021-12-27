//
//  OverviewTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import UIKit
import Firebase

class OverviewTableViewController: UITableViewController {
    
    // Variables
    var overviews = [OverviewInfo]()
    var name = ""
    private var db = Firestore.firestore()
    private var overviewsCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadData()
    }
    

        
    @IBAction func addOverviewButtonPressed(_ sender: Any) {
        
        
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "AddOverviewVC") as? AddOverviewsViewController else {return}
        nvc.name = name
        navigationController?.present(nvc, animated: true, completion: nil)
    }
    
    
    var originalDocumentId = ""
    func loadData(){
        
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
                
                    let originalDocumentId = document.documentID
                    
                    if self.name == elderName{
                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (elder) in the collection (center_elders)
                                for overviewDocument in snap.documents {
                                    let data = overviewDocument.data()

                                    // Stores specific data points as a variables
                                    let overview = data["overview"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let overviewDocumentId = overviewDocument.documentID
                                    
                                    let newOverview = OverviewInfo(id: overviewDocumentId, title: title, overview: overview)
                                    
                                    self.overviews.append(newOverview)
                        }
                                
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
        // #warning Incomplete implementation, return the number of rows
        return overviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let overviewCell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as? overviewCell

        // Configure the cell...
        overviewCell?.configureCell(overviewInfo:overviews[indexPath.row])

        return overviewCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewOverviewVC") as? ViewOverviewViewController

        self.navigationController?.pushViewController(vc!, animated: true)

        vc?.name = name
        vc?.id = overviews[indexPath.row].id
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
