//
//  ViewOverviewViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import UIKit
import Firebase

class ViewOverviewViewController: UIViewController {
    
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
        
        overviewsCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")
        
        overviewTitleTextField.isUserInteractionEnabled = false
        overviewBodyTextField.isUserInteractionEnabled = false
        
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
                    
                    if self.name == elderName{
                        print("ELDERNAME")
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
                                    
                                    if overviewDocumentId == self.id {
                                        
                                        let newOverview = OverviewInfo(id: overviewDocumentId, title: title, overview: overview)
                                        
                                        self.overviews.append(newOverview)
                                        
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
        overviewTitleTextField.text = overviews[0].title
        overviewBodyTextField.text = overviews[0].overview
    }
    

    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        buttonCounter += 1
        
        if buttonCounter % 2 != 0{
            editBarButton.title = "Save"
            
            overviewTitleTextField.isUserInteractionEnabled = true
            overviewBodyTextField.isUserInteractionEnabled = true
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

                                    // Iterates through each note document in the collection (notes)
                                    for overviewDocument in snap.documents {
                                        let data = overviewDocument.data()

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
                    
                    if self.name == elderName{
                        self.overviewsCollectionRef.document(originalDocumentId).collection("daily_overviews").getDocuments { [self] (snapshot, error) in
                            
                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each note document in the collection (notes)
                                for overviewDocument in snap.documents {
                                    let data = overviewDocument.data()

                                    // Stores specific data points as a variables
                                    let overviewDocumentId = overviewDocument.documentID
                                    
                                    if overviewDocumentId == self.id {
                                        
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
