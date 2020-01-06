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
    @IBOutlet var detailTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(property: TableData) {
        titleLabel.text = property.title
        detailTextView.text = property.detail
        if property.title == "APN" {
            detailTextView.dataDetectorTypes = .lookupSuggestion
        } else {
            detailTextView.dataDetectorTypes = .all
        }
    }
}
