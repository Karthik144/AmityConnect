//
//  CenterInfoTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/24/21.
//

import UIKit
import Firebase

class CenterInfoTableViewController: UITableViewController {
    
    // IB Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var centerIdTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    // Variables
    private var db = Firestore.firestore()
    private var centersCollectionRef: CollectionReference!
    var centers = [CenterInfo]()
    //var edit = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centersCollectionRef = db.collection("centers")
        
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
                    
                    // Iterates through each document (elder) in the collection (center_elders)
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
    
    var buttonCounter = 0
    // Edit button is pressed

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        buttonCounter += 1
        
        if buttonCounter % 2 != 0{
            
            barButton.title = "Save"

            locationTextField.isUserInteractionEnabled = true
            centerIdTextField.isUserInteractionEnabled = true
            directorTextField.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            
            
            centersCollectionRef.getDocuments { [self] (snapshot, error) in
                if let error = error {
                    print ("Error fetching documents: \(error)")
                    } else {
                        guard let snap = snapshot else {
                            return
                        }
                        
                        // Iterates through each document (elder) in the collection (center_elders)
                        for document in snap.documents {
                            let data = document.data()
                            let centerId = data["center_id"] as? String ?? ""
                            
                            for center in self.centers {
                                if centerId == center.centerId{
                                    self.centersCollectionRef.document(document.documentID).setData(["center_id":self.centerIdTextField.text ?? "", "director":self.directorTextField.text ?? "", "location": self.locationTextField.text ?? "", "member_since":self.dateTextField.text ?? ""])
                                }
                            }
                            
                        }
                        
                    }
            }
            
        } else {
            
            barButton.title = "Edit"
            
            locationTextField.isUserInteractionEnabled = false
            centerIdTextField.isUserInteractionEnabled = false
            directorTextField.isUserInteractionEnabled = false
            dateTextField.isUserInteractionEnabled = false
            
        
            
        }
        
  
        
    }
    
    }
    
    

