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
    func didBeginEditing(searchBar: UISearchBar)
    func didTap(button: UIButton)
}

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let mapVC = MapVC()
    private var cityDictionary = [String: Int]()
    var cities = [(city: String, count: Int)]() {
        didSet {
            tableView.reloadData()
        }
    }
    var properties = [Property]() {
        didSet {
            filteredProperties = properties.filter { $0.propertycity == "LOS ANGELES" }
        }
    }
    private var filteredProperties = [Property]()
    private var searchProperties = [Property]()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Properties", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private var isProperties = false
    private var selectedIndexPath: IndexPath? = nil
    private var inSearchMode = false
    weak var delegate: SearchVCDelegate?
    var isUp = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        listButton.addTarget(self, action: #selector(listButtonTapped(_:)), for: .touchUpInside)
        tableView.register(PropertyCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func viewDidSwipeDown() {
        guard let indexPath = selectedIndexPath else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
    }
    
    @objc func listButtonTapped(_ sender: UIButton) {
        delegate?.didSelect(list: sender)
        if sender.titleLabel?.text == "Properties" {
            isProperties = true
            searchBar.animate(isHidden: false)
            listButton.setTitle("Cities", for: .normal)
            tableView.reloadData()
        } else {
            searchBar.animate(isHidden: true)
            isProperties = false
            listButton.setTitle("Properties", for: .normal)
            searchBar.searchTextField.resignFirstResponder()
            tableView.reloadData()
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isUp.toggle()
        delegate?.didTap(button: sender)
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CITIES"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProperties {
            return filteredProperties.count
        } else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PropertyCell
        if isProperties {
            let property = filteredProperties[indexPath.row]
            cell.configure(property)
        } else {
            let city = cities[indexPath.row]
            cell.configure(city.city,
                           selectedIndexPath: &selectedIndexPath,
                           indexPath: indexPath,
                           numberOfProperties: "Number of Properties: \(city.count)")
        }
        return cell
    }
}

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if !isProperties {
            let city = cities[indexPath.row].city
            filteredProperties = properties.filter { $0.propertycity == city }
            delegate?.didSelect(city: city)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            selectedIndexPath = indexPath
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 80))
        headerView.backgroundColor = .white
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

extension SearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.didBeginEditing(searchBar: searchBar)
    }
}

