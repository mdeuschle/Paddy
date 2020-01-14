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
        let cgSize = CGSize(width: -1.5, height: 3)
        layer.shadowOffset = cgSize
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.28
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}


