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
        let cgSize = CGSize(width: 0, height: 2)
        layer.shadowOffset = cgSize
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}


