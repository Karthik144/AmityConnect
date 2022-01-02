//
//  familyElderSpecificTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/31/21.
//

import UIKit

class familyElderSpecificTableViewController: UITableViewController {

    // IB Outlets
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var elderImage: UIImageView!


    // Variables
    var name = ""
    var age = ""
    var condition = ""
    var gender = ""

    override func viewDidLoad() {
        super.viewDidLoad()

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

        if gender == "Male"{
            elderImage.image = UIImage(named: "elderMan")
        } else if gender == "Female"{
            elderImage.image = UIImage(named: "elderWoman")
        }
    }


    // Sets the background color of each cell to white
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.white
    }

}
