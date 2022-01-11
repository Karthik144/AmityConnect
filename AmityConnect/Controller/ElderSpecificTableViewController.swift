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
    @IBOutlet weak var heartRateView: LineChartView!
    @IBOutlet weak var heartRateTextField: UITextField!
    @IBOutlet weak var bloodPressureTextField: UITextField!
    @IBOutlet weak var glucoseLevelTextField: UITextField!
    @IBOutlet weak var oxidationLevelTextField: UITextField!
    @IBOutlet weak var healthAddButton: UIButton!
    @IBOutlet weak var currentHeartRate: UILabel!
    @IBOutlet weak var activityProgressBar: UIProgressView!
    @IBOutlet weak var moodProgressBar: UIProgressView!


    // Variables
    private var db = Firestore.firestore()
    var lineChart = LineChartView()
    private var elders = [ElderOverview]()
    private var data = [HealthData]()
    private var mentalData = [MentalHealthData]()
    let rightBarDropDown = DropDown()
    private var eldersCollectionRef: CollectionReference!
    var name = ""
    var smartDeviceStatus = ""
    var age = ""
    var condition = ""
    var gender = ""
    var count = 0
    var mentalHealthCount = 0
    var maxDate = Date(timeIntervalSince1970: 100)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizes the chart's axises
        heartRateView.rightAxis.enabled = false
        let yAxis = heartRateView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)

        heartRateView.xAxis.labelPosition = .bottom
        heartRateView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        heartRateView.xAxis.setLabelCount(6, force: false)

        heartRateView.doubleTapToZoomEnabled = false
        heartRateView.legend.enabled = false

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
        heartRateTextField.isUserInteractionEnabled = false
        bloodPressureTextField.isUserInteractionEnabled = false
        glucoseLevelTextField.isUserInteractionEnabled = false
        oxidationLevelTextField.isUserInteractionEnabled = false

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

        // If elders has not device, then add button appears
        if smartDeviceStatus == "No Device"{
            healthAddButton.alpha = 1
            loadHealthData()
        } else {
            healthAddButton.alpha = 0
        }

        // Loads mental health data
        loadMentalHealthData()

        // If add button has not been pressed yet, place holder text is placed
        if count == 0 && smartDeviceStatus == "No Device" {

            heartRateTextField.text = "Heart Rate: No data added"
            bloodPressureTextField.text = "Blood Pressure: No data"
            glucoseLevelTextField.text = "Glucose Level: No data"
            oxidationLevelTextField.text = "Oxidation Level: No data"
        }
    }

    func setupData(){

        // Creates a list of ChartDataEntry type
        var entries = [ChartDataEntry]()

        print("TESTER")

        // Creates a new empty list that will sort from lowest to greatest int values
        var sortedList = [Int]()

        // Creates a counter variable (NEEDS TO BE CHANGED)
        var count = 0

        for each in data{

            count += 1

            if each.name == name{

                print("TEST")

                // Converts the string to an int and stores it in a variable
                let heartRateValue = Int(each.heart_rate)

                // Appends the sortedList with the heartRateValue as an Int
                sortedList.append(heartRateValue ?? 0)

                // Sorts the list from lowest to greatest
                sortedList.sort()

                print(sortedList)

                // Appends each data point to the chart to be displayed
                for dataPoint in sortedList{

                    entries.append(ChartDataEntry(x: Double(count), y: Double(dataPoint)))

                }

            }
        }

        // Sets entries and data through LineChart methods
        let set = LineChartDataSet(entries: entries, label: "Heart Rate Values")

        // Customizes the set
        set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(.systemBlue)
        set.fill = Fill(color: .systemBlue)
        set.fillAlpha = 0.2
        set.drawFilledEnabled = true
        set.setCircleColors(.systemBlue)
        set.circleRadius = 2.0
        set.highlightColor = .systemRed
        set.highlightLineWidth = 1.5

        let data = LineChartData(dataSet: set)

        lineChart.data = data
        data.setDrawValues(true)

        // Sets color of line chart
        set.colors = ChartColorTemplates.material()

        self.heartRateView.data = data
    }


    func loadHealthData(){

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
                    let elderName = data["name"] as? String ?? ""
                    //let gender = data["gender"] as? String ?? ""
                    let originalDocumentId = document.documentID

                    // Checks if the document is for the selected elder
                    if self.name == elderName {

                        self.eldersCollectionRef.document(originalDocumentId).collection("health_data").getDocuments { (snapshot, error) in

                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (healthDocument) in the collection ("health_data")
                                for healthDocument in snap.documents {
                                    let data = healthDocument.data()

                                    // Stores specific data points as a variables
                                    let bloodPressure = data["blood_pressure"] as? String ?? ""
                                    let date = data["date"] as! Timestamp
                                    let glucoseLevel = data["glucose_level"] as? String ?? ""
                                    let heartRate = data["heart_rate"] as? String ?? ""
                                    let oxidationLevel = data["oxidation_level"]
                                    let healthDocumentId = healthDocument.documentID

                                    let newDate = date.dateValue()

                                    // Creates a new HealthData structure instance
                                    let newHealthData = HealthData(id: healthDocumentId, name: elderName, blood_pressure: bloodPressure, date: newDate, glucose_level: glucoseLevel, heart_rate: heartRate, oxidation_level: oxidationLevel as! String)

                                    // Adds newly created HealthData instance to the list of data
                                    self.data.append(newHealthData)

                                    // Calls the input data function
                                    self.inputData()

                                    // Calls function to input data into the heartRate chart
                                    self.setupData()

                                }

                            }

                        }
                    }



                }


            }
        }
    }



    func inputData(){

        // Sets text fields and labels with data from backend 
        heartRateTextField.text = data[0].heart_rate
        bloodPressureTextField.text = data[0].blood_pressure
        glucoseLevelTextField.text = data[0].glucose_level
        oxidationLevelTextField.text = data[0].oxidation_level
        currentHeartRate.text = data[0].heart_rate + " BPM"

    }

    func loadMentalHealthData(){

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
                    let elderName = data["name"] as? String ?? ""
                    let originalDocumentId = document.documentID

                    // Checks if the document is for the selected elder
                    if self.name == elderName {

                        self.eldersCollectionRef.document(originalDocumentId).collection("mental_health_data").getDocuments { (snapshot, error) in

                            if let error = error {
                                print ("Error fetching documents: \(error)")
                            } else {
                                guard let snap = snapshot else {
                                    return
                                }

                                // Iterates through each document (mentalHealthDocument) in the collection ("mental_health_data")
                                for mentalHealthDocument in snap.documents {
                                    let data = mentalHealthDocument.data()

                                    // Stores specific data points as a variables
                                    let activityLevel = data["activity_level"] as? Float ?? 0.0
                                    let date = data["date"] as! Timestamp
                                    let additionalNotes = data["additional_notes"] as? String ?? ""
                                    let moodLevel = data["mood_level"] as? Float ?? 0.0
                                    let mentalHealthDocumentId = mentalHealthDocument.documentID

                                    let newDate = date.dateValue()

                                    // Creates a new MentalHealthData structure instance
                                    let newMentalHealthData = MentalHealthData(id: mentalHealthDocumentId, name: elderName, activity_level: activityLevel, date: newDate, additional_notes: additionalNotes, mood_level: moodLevel)

                                    // Adds newly created MentalHealthData instance to the list of data
                                    self.mentalData.append(newMentalHealthData)

                                    // Calls the input data function
                                    self.inputMentalHealthData()

                                }

                            }

                        }
                    }



                }


            }
        }


    }


    func inputMentalHealthData() {

        print("ENTERED")

        print(mentalData[0].activity_level)

        // Sets the progress level based on the data from Firestore
        activityProgressBar.setProgress(Float(mentalData[0].activity_level), animated: false)
        moodProgressBar.setProgress(Float(mentalData[0].mood_level), animated: false)

    }



    @IBAction func mentalHealthAddButtonPressed(_ sender: UIButton) {

        mentalHealthCount += 1

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addMentalHealthData") as? AddMentalHealthDataViewController
        vc?.name = self.name
        self.navigationController?.present(vc!, animated: true)

        
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {

        count += 1

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addHealthData") as? AddHealthDataViewController
        vc?.name = self.name
        self.navigationController?.present(vc!, animated: true)


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


        }

        if buttonCounter % 2 != 0 && smartDeviceStatus == "No Device"{

            heartRateTextField.isUserInteractionEnabled = true
            bloodPressureTextField.isUserInteractionEnabled = true
            glucoseLevelTextField.isUserInteractionEnabled = true
            oxidationLevelTextField.isUserInteractionEnabled = true

        }

        // Otherwise, don't let the user edit (just view data)
        else {
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

                            for each in self.data{

                                if each.name == name {
                                    eldersCollectionRef.document(document.documentID).collection("health_data").document(each.id).setData(["blood_pressure": bloodPressureTextField.text ?? "", "date": each.date , "glucose_level": glucoseLevelTextField.text ?? "", "heart_rate": heartRateTextField.text ?? "", "oxidation_level": oxidationLevelTextField.text ?? "", "name": each.name])
                                }
                            }
                            
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


