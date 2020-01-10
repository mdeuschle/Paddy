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
        layer.cornerRadius = 10
        layer.shadowOffset = .zero
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.35
        layer.shadowColor = UIColor.black.cgColor
        let cgSize = CGSize(width: 10, height: 10)
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: .allCorners,
            cornerRadii: cgSize).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}


