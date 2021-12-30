//
//  profileElderCell.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/23/21.
//

import Foundation
import UIKit

class profileElderCell : UITableViewCell {
    
    // IB Outlets
    @IBOutlet weak var elderName: UILabel!
    @IBOutlet weak var elderImage: UIImageView!
    
    // Sets the text label to data derived from Firebase
    func configureCell(elderOverview: ElderOverview){
        elderName.text = elderOverview.name
    }
    
}
