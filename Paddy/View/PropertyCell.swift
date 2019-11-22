//
//  PropertyCell.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/21/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ city: String, selectedIndexPath: inout IndexPath?, indexPath: IndexPath) {
        textLabel?.text = city
        detailTextLabel?.text = ""
        selectionStyle = .none
        if city == "LOS ANGELES" && selectedIndexPath?.row == nil {
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
        accessoryType = .none
        textLabel?.text = property.propertyaddress
        detailTextLabel?.text = property.propertyzip
    }
}
