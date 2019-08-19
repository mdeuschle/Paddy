//
//  ViewController.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProperties()
    }
    
    private func downloadProperties() {
        PropertyStore.shared.downloadProperties { result in
            switch result {
            case let .success(jsons):
                for json in jsons {
                    let property = Property(propertyJSON: json)
                    print("PROP: \(property.propertyJSON?.lender)")
                }
            case let .failure(error):
                print("ERROR: \(error)")
            }
        }
    }
}

