//
//  ColorExtension.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/12/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var blackFont: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .black
        }
    }
    
    static var greyFont: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .systemGray
                }
            }
        } else {
            return .black
        }
    }
}

