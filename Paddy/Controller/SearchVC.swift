//
//  SearchVCViewController.swift
//  Paddy
//
//  Created by Matt Deuschle on 10/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

protocol SearchVCDelegate: AnyObject {
    func didSelect(city: String)
    func didSelect(list: UIButton)
}

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var cities = [String]()
    private var dataSource: DataSource?
    var properties = [Property]() {
        didSet {
            loadCities()
        }
    }
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Properties", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private var selectedIndexPath: IndexPath? = nil
    weak var delegate: SearchVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        listButton.addTarget(self, action: #selector(listButtonTapped(_:)), for: .touchUpInside)
        loadCities()
    }
    
    func viewDidSwipeDown() {
        guard let indexPath = selectedIndexPath else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    @objc func listButtonTapped(_ sender: UIButton) {
        delegate?.didSelect(list: sender)
        if sender.titleLabel?.text == "Properties" {
            dataSource = .property
            listButton.setTitle("Cities", for: .normal)
        } else {
            dataSource = .city
            listButton.setTitle("Properties", for: .normal)
            loadCities()
        }
    }
    
    private func loadCities() {
        let citiesArray = properties.compactMap { $0.propertycity }
        cities = Array(Set(citiesArray)).sorted().filter { !$0.contains("APN") }
        dataSource = .city
        tableView.reloadData()
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        switch dataSource {
        case .city:
            let city = cities[indexPath.row]
            cell.textLabel?.text = city
            cell.selectionStyle = .none
            if city == "LOS ANGELES" && selectedIndexPath?.row == nil {
                selectedIndexPath = indexPath
            }
            if let selectedIndexPath = selectedIndexPath {
                if indexPath == selectedIndexPath {
                    cell.accessoryType = .checkmark
                    cell.isSelected = true
                } else {
                    cell.accessoryType = .none
                    cell.isSelected = false
                }
            }
        default:
            cell.textLabel?.text = properties[indexPath.row].propertyaddress ?? ""
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
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 80))
        headerView.backgroundColor = .red
        headerView.addSubview(listButton)
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.contentHorizontalAlignment = .trailing
        NSLayoutConstraint.activate([
            listButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            listButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            listButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            listButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        return headerView
    }
}
