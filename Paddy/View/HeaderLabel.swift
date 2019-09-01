//
//  HeaderLabel.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with message: String, view: UIView) {
        text = message
        font = UIFont.preferredFont(forTextStyle: .headline)
        textAlignment = .left
        adjustsFontForContentSizeCategory = true
        numberOfLines = 0
        configureContraints(for: view)
    }
    
    private func configureContraints(for view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: guide.topAnchor, constant: 22),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 23),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 23)
        ])
    }
}
