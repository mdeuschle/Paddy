//
//  ContainerView.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/4/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

final class ContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
}


