//
//  ElderSpecificTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/23/21.
//

import UIKit
import Firebase
import DropDown
import Charts

class ElderSpecificTableViewController: UITableViewController, ChartViewDelegate {
    
    
    // IB Outlets
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var elderAssessButton: UIBarButtonItem!
    @IBOutlet weak var elderImage: UIImageView!
    @IBOutlet weak var heartRateView: BarChartView!

    // Variables
    private var db = Firestore.firestore()
    var lineChart = LineChartView()
    var elders = [ElderOverview]()
    let rightBarDropDown = DropDown()
    private var eldersCollectionRef: CollectionReference!
    var name = ""
    var age = ""
    var condition = ""
    var gender = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the line chart and view delegate to self
        lineChart.delegate = self
        heartRateView.delegate = self


        // Sets textfields to the data collected from HomeVC
        ageTextField.text = age
        conditionTextField.text = condition
        genderTextField.text = gender

        // Sets the title and color of the view
        self.title = name
        self.tableView.backgroundColor = UIColor.white

        // Prevents user from interacting with textfields until edit button is pressed
        ageTextField.isUserInteractionEnabled = false
        conditionTextField.isUserInteractionEnabled = false
        genderTextField.isUserInteractionEnabled = false


        // Creates a reference to center_elders
        eldersCollectionRef = db.collection("centers").document("Wo5A6ujH3jhPUfWnaIkI").collection("center_elders")

        // Checks the gender of the elder and sets a corresponding image
        if gender == "Male"{
            elderImage.image = UIImage(named: "elderMan")
        } else if gender == "Female"{
            elderImage.image = UIImage(named: "elderWoman")
        }

        // Sets the drop down view
        rightBarDropDown.anchorView = elderAssessButton
        rightBarDropDown.dataSource = ["ADL", "Daily Overview", "Notes"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }

        setupData()
        
    }

    func setupData(){

        lineChart.frame = CGRect(x: 0, y: 0, width: heartRateView.frame.size.width, height: heartRateView.frame.size.width)
        //heartRateView.addSubview(lineChart)

        var entries = [ChartDataEntry]()

        lineChart.center = heartRateView.center

        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }

        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()


        let data = LineChartData(dataSet: set)
        //lineChart.data = data
        //data.setDrawValues(true)
        heartRateView.data = data


    }

    // Sets the background color of each cell to white
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.white
    }

    // Creates an accumulator variable
    var buttonCounter = 0
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        // Adds to the variable every time button is pressed
        buttonCounter += 1

        // If button is pressed an odd amount of times, then allow the user to edit
        if buttonCounter % 2 != 0 {
            
            barButton.title = "Save"
            
            ageTextField.isUserInteractionEnabled = true
            conditionTextField.isUserInteractionEnabled = true
            genderTextField.isUserInteractionEnabled = true

            // Otherwise, don't let the user edit (just view data)
        } else {
            barButton.title = "Edit"
            
            ageTextField.isUserInteractionEnabled = false
            conditionTextField.isUserInteractionEnabled = false
            genderTextField.isUserInteractionEnabled = false
            
            
            eldersCollectionRef.getDocuments { [self] (snapshot, error) in
                if let error = error {
                    print ("Error fetching documents: \(error)")
                } else {
                    guard let snap = snapshot else {
                        return
                    }
                    
                    // Iterates through each document (elder) in the collection (center_elders)
                    for document in snap.documents {
                        let data = document.data()
                        
                        // Sets data from Firebase as a variable
                        let caretaker = data["caretaker"] as? String ?? ""
                        let familyEmail = data["family_email"] as? String ?? ""
                        let elderName = data["name"] as? String ?? ""
                        
                        // If selected elder name is equal to the elderName in the document, upload edited data to the document 
                        if name == elderName {
                            eldersCollectionRef.document(document.documentID).setData(["age": ageTextField.text ?? "", "caretaker":caretaker, "condition":conditionTextField.text ?? "", "family_email":familyEmail, "gender":genderTextField.text ?? "", "name":elderName])
                            
                        }
                        
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    @IBAction func elderAssessButtonPressed(_ sender: UIBarButtonItem) {

        rightBarDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            // If index 2 is selected, direct the user to Notes
            if index == 2{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotesVC") as? NotesTableViewController
                vc?.name = self.name
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }

            // If index 1 is selected, direct the user to Overviews
            if index == 1{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OverviewVC") as? OverviewTableViewController
                vc?.name = self.name
                self.navigationController?.pushViewController(vc!, animated: true)
            }

            // If index 0 is selected, direct the user to ADLs
            if index == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdlVC") as? ADLTableViewController
                vc?.name = self.name
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }

        // Style the drop down
        rightBarDropDown.width = 130
        rightBarDropDown.cornerRadius = 10
        rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
        rightBarDropDown.show()
        
    }
    
    
}


