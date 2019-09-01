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
    let cities = ["Los Angeles", "Van Nuys", "Chicago"]
    private var rowHeight: CGFloat = 8

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
        let pickerView = UIPickerView()
        pickerView.delegate = self
        chooseCityTextField.inputView = pickerView
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

extension ChooseCityVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return cities[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseCityTextField.text = cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let _view = view { label = _view as! UILabel }
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.text = cities[row]
        label.textAlignment = .center
        rowHeight = label.font.lineHeight
        return label
    }
//
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
}
