//
//  ViewController.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let propertyStore = PropertyStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProperties()
    }
    
    private func downloadProperties() {
        propertyStore.downloadProperties { result, cities in
            switch result {
            case .success(_):
                print(cities)
            case let .failure(error):
                print("ERROR: \(error)")
            }
        }
    }
}

