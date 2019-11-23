//
//  UIViewExtension.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/22/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

extension UIView {
    func animate(isHidden: Bool) {
        UIView.transition(with: self,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.isHidden = isHidden
        }, completion: nil)
    }
}
