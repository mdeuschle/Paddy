//
//  SearchVCViewController.swift
//  Paddy
//
//  Created by Matt Deuschle on 10/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

protocol SearchVCDelegate: AnyObject {
    func didSelect(city: String)
}

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var cities = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var properties = [Property]()
    private var selectedRow: Int? = nil
    weak var delegate: SearchVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
    }
}


extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CITIES"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let city = cities[indexPath.row]
        cell.textLabel?.text = city
        cell.selectionStyle = .none
        if city == "LOS ANGELES" && selectedRow == nil {
            selectedRow = indexPath.row
        }
        if let selectedRow = selectedRow {
            if indexPath.row == selectedRow {
                cell.accessoryType = .checkmark
                cell.isSelected = true
            } else {
                cell.accessoryType = .none
                cell.isSelected = false
            }
        }
        return cell
    }
}

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        delegate?.didSelect(city: city)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}
