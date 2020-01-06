//
//  ShadowView.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/4/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

final class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            addShadow()
        }
    }
}
