//
//  AddMentalHealthDataViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 1/10/22.
//

import UIKit
import Firebase

class AddMentalHealthDataViewController: UITableViewController {

    // IB Outlets
    @IBOutlet weak var moodSlider: UISlider!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var additionalNotesTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!


    // Variables
    var name = ""
    var documentId = ""
    private var elders = [ElderOverview]()
    private var db = Firestore.firestore()
    private var eldersCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        loadData()
    }

    func loadData() {

        // Retrieves data from Firestore
        eldersCollectionRef.getDocuments { (snapshot, error) in
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
                    let age = data["age"] as? String ?? ""
                    let caretaker = data["caretaker"] as? String ?? ""
                    let condition = data["condition"] as? String ?? ""
                    let familyEmail = data["family_email"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    let documentId = document.documentID


                    // Creates an ElderOverview Structure with the retrieved data from each document
                    let newElderOverview = ElderOverview(id: documentId, age: age, gender: gender, caretaker: caretaker, condition: condition, family_email: familyEmail, name: name)

                    // Adds each created ElderOverview structure to the elders list
                    self.elders.append(newElderOverview)

                }
            }
        }

    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {

        // Finds the elder's document id
        for elder in elders{
            if elder.name == name{
                documentId = elder.id

            }
        }

        // Creates a new collection under that elder's name
        let newDocument = eldersCollectionRef.document(documentId).collection("mental_health_data").document()

        newDocument.setData(["mood_level": moodSlider.value, "activity_level": activitySlider.value, "additional_notes": additionalNotesTextField.text ?? "", "date": datePicker.date])

        // Dismisses the view once the log button is pressed
        dismiss(animated: true, completion: nil)


    }


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {

        // Dismisses the view once the log button is pressed
        dismiss(animated: true, completion: nil)
    }

}
