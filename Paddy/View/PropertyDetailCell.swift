//
//  PropertyDetailCell.swift
//  Paddy
//
//  Created by Matt Deuschle on 12/5/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class PropertyDetailCell: UITableViewCell {
    
    @IBOutlet var propertyImage: UIImage!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
