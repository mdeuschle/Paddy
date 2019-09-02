//
//  ChooseCityVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ChooseCityVC: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .gray)
    let propertyStore = PropertyStore()
    private var rowHeight: CGFloat = 46
    let pickerView = UIPickerView()
    private var chooseCityTextField = ChooseCityTextField()
    var properties = [Property]()
    var cities = [String]() {
        didSet {
            pickerView.reloadAllComponents()
            chooseCityTextField.text = cities.first?.capitalized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProperties()
        setUpUI()
    }
    
    private func setUpUI() {
        title = "Paddy"
        navigationController?.navigationBar.prefersLargeTitles = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        let pickerLabel = HeaderLabel()
        view.addSubview(pickerLabel)
        pickerLabel.configure(with: "Choose City", view: view)
        view.addSubview(chooseCityTextField)
        chooseCityTextField.configure(view: pickerLabel)
        pickerView.delegate = self
        chooseCityTextField.inputView = pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        chooseCityTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        chooseCityTextField.resignFirstResponder()
        print("TAP")
    }
    
    private func downloadProperties() {
        propertyStore.downloadProperties { [unowned self] result, cities in
            self.spinner.stopAnimating()
            switch result {
            case let .success(properties):
                self.cities = cities ?? [String]()
                self.properties = properties
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseCityTextField.text = cities[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let _view = view { label = _view as! UILabel }
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.text = cities[row].capitalized
        label.textAlignment = .center
        rowHeight = label.font.lineHeight
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
}
