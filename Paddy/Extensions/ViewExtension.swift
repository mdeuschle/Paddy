//
//  ViewExtension.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/4/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow() {
        clipsToBounds = false
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.darkGray.cgColor
        let cgSize = CGSize(width: 5, height: 5)
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: .allCorners,
            cornerRadii: cgSize).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
