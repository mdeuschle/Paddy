//
//  ShadowCell.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/5/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

class ShadowCell: UITableViewCell {
    
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
