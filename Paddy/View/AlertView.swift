//
//  AlertView.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/21/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

struct AlertView {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(error: String) {
        let message = """
        \(error)
        Please try again later
        """
        let alertView = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
        alertView.addAction(action)
        viewController.present(alertView, animated: true, completion: nil)
    }
}
