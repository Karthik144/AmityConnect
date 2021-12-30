//
//  overviewCell.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import Foundation
import UIKit

class overviewCell : UITableViewCell {
    
    
    // IB Outlets
    @IBOutlet weak var overviewTitleLabel: UILabel!

    // Sets the text label to data derived from Firebase 
    func configureCell(overviewInfo: OverviewInfo){
        overviewTitleLabel.text = overviewInfo.title
    }
}
