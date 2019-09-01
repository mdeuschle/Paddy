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
    private var chooseCityTextField = ChooseCityTextField()

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
        view.addSubview(chooseCityTextField)
        chooseCityTextField.configure(view: pickerLabel)
        chooseCityTextField.text = "Los Angeles"
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
