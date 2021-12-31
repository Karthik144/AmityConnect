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

        // Creates a reference to center_elders collection
        overviewsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Loads data once view loads
        loadData()
    }
    

        
    @IBAction func addOverviewButtonPressed(_ sender: Any) {
        
        // Presents a pop up vc (AddOverviewVC) when the bar button item is pressed
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "AddOverviewVC") as? AddOverviewsViewController else {return}

        //Passes the name variable over when it presents the controller
        nvc.name = name
        navigationController?.present(nvc, animated: true, completion: nil)
    }
    
    // Creates a global variable for document id that can be used throughout
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

                    // If elder name is the name that was passed to this vc, then add its overview data
                    if self.name == elderName{
                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (elder) in the collection (overview)
                                for overviewDocument in snap.documents {
                                    let data = overviewDocument.data()

                                    // Stores specific data points as a variables
                                    let overview = data["overview"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let overviewDocumentId = overviewDocument.documentID

                                    // Creates a new overview with the OverviewInfo model and adds the stored data into it
                                    let newOverview = OverviewInfo(id: overviewDocumentId, title: title, overview: overview)

                                    // Appends the newOverview to the list of OverviewInfo models
                                    self.overviews.append(newOverview)
                        }

                                // Reloads table view
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

        // Sets the number of rqws equal to the number of items in the overviews list
        return overviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let overviewCell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as? overviewCell

        // Configures the cell by calling the configureCell function that sets the text label
        overviewCell?.configureCell(overviewInfo:overviews[indexPath.row])

        return overviewCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Pushes the ViewOverviewVC when a specific notes cell is selected
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewOverviewVC") as? ViewOverviewViewController

        self.navigationController?.pushViewController(vc!, animated: true)

        vc?.name = name
        vc?.id = overviews[indexPath.row].id
    }


}
