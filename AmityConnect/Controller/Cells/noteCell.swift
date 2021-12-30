//
//  noteCell.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import Foundation
import UIKit

class noteCell : UITableViewCell {

    // IB Outlets
    @IBOutlet weak var noteTitleLabel: UILabel!
    

    // Sets the text label to data derived from Firebase
    func configureCell(notesInfo: NotesInfo){
        noteTitleLabel.text = notesInfo.title
    }
}
