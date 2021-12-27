//
//  elderCell.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/22/21.
//

import Foundation
import UIKit

class elderCell : UITableViewCell {
    
    // IB Outlets
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var careTakerLabel: UILabel!
    
    
    func configureCell(elderOverview: ElderOverview){
        cellLabel.text = elderOverview.name
        careTakerLabel.text = elderOverview.caretaker
    }
    
}


