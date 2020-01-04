//
//  PropertyCell.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/21/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

final class PropertyCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    func configure(_ city: String,
                   selectedIndexPath: inout IndexPath?,
                   indexPath: IndexPath,
                   numberOfProperties: String) {
        titleLabel.text = city
        detailLabel.text = numberOfProperties
        selectionStyle = .none
        if city == "LOS ANGELES", selectedIndexPath?.row == nil {
            selectedIndexPath = indexPath
        }
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                accessoryType = .checkmark
                isSelected = true
            } else {
                accessoryType = .none
                isSelected = false
            }
        }
    }
    
    func configure(_ property: Property) {
        accessoryType = .disclosureIndicator
        titleLabel.text = property.propertyaddress
        detailLabel.text = property.registered_date?.dateString()
    }
}
