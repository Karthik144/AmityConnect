//
//  FamilyCenterInfoTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/31/21.
//

import UIKit
import Firebase

class FamilyCenterInfoTableViewController: UITableViewController {


    // IB Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var centerIdTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!

    // Variables
    private var db = Firestore.firestore()
    private var centersCollectionRef: CollectionReference!
    var centers = [CenterInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates a reference to the collection "centers"
        centersCollectionRef = db.collection("centers")

        // Prevents user from editing until edit button is pressed
        locationTextField.isUserInteractionEnabled = false
        centerIdTextField.isUserInteractionEnabled = false
        directorTextField.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false

        loadData()


    }

    func loadData(){

        // Retrieves data from Firestore
        centersCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print ("Error fetching documents: \(error)")
            } else {
                guard let snap = snapshot else {
                    return
                }

                // Iterates through each document (center info) in the collection (center)
                for document in snap.documents {
                    let data = document.data()

                    // Stores specific data points as a variables
                    let centerId = data["center_id"] as? String ?? ""
                    let director = data["director"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let date = (data["member_since"] as? Timestamp)?.dateValue() ?? Date()


                    // Creates an CenterInfo Structure with the retrieved data from each document
                    let newCenter = CenterInfo(centerId: centerId, director: director, location: location, memberSince: date)

                    // Adds each created CenterInfo structure to the elders list
                    self.centers.append(newCenter)

                    // Calls input data function to enter retrieved data into the text fields
                    self.inputData()

                }

            }

        }

    }


    func inputData() {
        locationTextField.text = centers[0].location
        centerIdTextField.text = centers[0].centerId
        directorTextField.text = centers[0].director
        dateTextField.text = centers[0].memberSinceString
    }


}
