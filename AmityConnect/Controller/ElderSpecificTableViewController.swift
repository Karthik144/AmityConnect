//
//  ElderSpecificTableViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/23/21.
//

import UIKit

class ElderSpecificTableViewController: UITableViewController {
    
    
    // IB Outlets
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    // Variables
    var name = ""
    var age = ""
    var condition = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageLabel.text = age
        conditionLabel.text = condition
        self.title = name


    }
    
    
    


}
