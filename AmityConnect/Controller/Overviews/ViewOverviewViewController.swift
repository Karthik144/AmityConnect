//
//  ViewOverviewViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import UIKit
import Firebase

class ViewOverviewViewController: UIViewController {

    // IB Outlets
    @IBOutlet weak var overviewTitleTextField: UITextField!
    @IBOutlet weak var overviewBodyTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // Variables
    var overviews = [OverviewInfo]()
    var name = ""
    var id = ""
    private var db = Firestore.firestore()
    private var overviewsCollectionRef:CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Creates a reference to the collection (center_elders)
        overviewsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Does not allow the user to edit any text (becasue user has not selected edit yet)
        overviewTitleTextField.isUserInteractionEnabled = false
        overviewBodyTextField.isUserInteractionEnabled = false

        // Calls the loadData function
        loadData()
    }
    
    func loadData(){
        
        //Retrieve data from Firestore
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

                    // If the name of the document is equal to the eldername that is passed through, enter into its notes collection
                    if self.name == elderName{
                        print("ELDERNAME")
                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (overview) in the collection (daily_overviews)
                                for overviewDocument in snap.documents {
                                    let data = overviewDocument.data()

                                    // Stores specific data points as a variables
                                    let overview = data["overview"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let overviewDocumentId = overviewDocument.documentID

                                    // Checks to see if it is the right ID
                                    if overviewDocumentId == self.id {

                                        // Creates a newOverview using the OverviewInfo Model
                                        let newOverview = OverviewInfo(id: overviewDocumentId, title: title, overview: overview)

                                        // Appends the newOverview into the overviews list
                                        self.overviews.append(newOverview)

                                        // Calls the input data function
                                        self.inputData()
                                        
                                    }

                                }
                                
                            }
                        }
                    }


                }



            }
            
        }
        
    }
    
    func inputData() {
        // Sets the textfield with data
        overviewTitleTextField.text = overviews[0].title
        overviewBodyTextField.text = overviews[0].overview
    }
    
    // Creates an accumulator variable
    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        // Adds to the counter each time the button is pressed
        buttonCounter += 1

        // If button is pressed an odd number of times, then allow use to edit
        if buttonCounter % 2 != 0{
            editBarButton.title = "Save"
            
            overviewTitleTextField.isUserInteractionEnabled = true
            overviewBodyTextField.isUserInteractionEnabled = true

            // Otherwise do not allow the user to edit
        } else {
            
            editBarButton.title = "Edit"
            
            overviewTitleTextField.isUserInteractionEnabled = false
            overviewBodyTextField.isUserInteractionEnabled = false
            
            //Retrieve data from Firestore
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
                            self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { [self] (snapshot, error) in
                                
                                if let error = error {
                                    print ("Error fetching documents: \(error)")
                                } else {
                                    guard let snap = snapshot else {
                                        return
                                    }

                                    // Iterates through each overview document in the collection (daily_overviews)
                                    for overviewDocument in snap.documents {

                                        // Stores specific data points as a variables
                                        let overviewDocumentId = overviewDocument.documentID
                                        
                                        if overviewDocumentId == self.id {
                                            
                                            self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").document(overviewDocumentId).setData(["overview": self.overviewBodyTextField.text ?? "", "title":self.overviewTitleTextField.text ?? ""])

                                            
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
    
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        //Retrieve data from Firestore
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

                    // Checks if the name that is passed through is equal to the document name
                    if self.name == elderName{
                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { [self] (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each overview document in the collection (daily_overviews)
                                for overviewDocument in snap.documents {

                                    // Stores specific data points as a variables
                                    let overviewDocumentId = overviewDocument.documentID
                                    
                                    if overviewDocumentId == self.id {

                                        // Deletes the note that has been selected
                                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").document(overviewDocumentId).delete()



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
