//
//  PInfoCell.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/14/21.
//

import UIKit

class PInfoCell: UITableViewCell {
    
    static let identifier = "PInfoCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "PInfoCell", bundle: nil)
    }
    
    public func configure(with title: String, imageName: String) {
        pInfoLabel.text = title
        pInfoImage.image = UIImage(systemName: imageName)
        
    }
    
    @IBOutlet var pInfoImage: UIImageView!
    @IBOutlet var pInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pInfoImage.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
