//
//  ChooseCityVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ChooseCityVC: UIViewController {
    
    let propertyStore = PropertyStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProperties()
        setUpUI()
    }
    
    private func setUpUI() {
        title = "Paddy"
        navigationController?.navigationBar.prefersLargeTitles = true
        let pickerLabel = HeaderLabel()
        view.addSubview(pickerLabel)
        pickerLabel.configure(with: "Choose City", view: view)
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
