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

        ageTextField.text = age
        conditionTextField.text = condition
        genderTextField.text = gender
        self.title = name

        ageTextField.isUserInteractionEnabled = false
        conditionTextField.isUserInteractionEnabled = false
        genderTextField.isUserInteractionEnabled = false

        if gender == "Male"{
            elderImage.image = UIImage(named: "elderMan")
        } else if gender == "Female"{
            elderImage.image = UIImage(named: "elderWoman")
        }
    }

}
