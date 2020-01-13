//
//  SearchVCViewController.swift
//  Paddy
//
//  Created by Matt Deuschle on 10/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

protocol SearchVCDelegate: AnyObject {
    func didSelect(city: String)
    func didBeginEditing(searchBar: UISearchBar)
    func didTap(button: UIButton)
}

import UIKit
import GoogleMobileAds

final class SearchVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let mapVC = MapVC()
    private var cityDictionary = [String: Int]()
    var cities = [(city: String, count: Int)]() {
        didSet {
            listButton.isHidden = false
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
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return button
    }()
    private var isProperties = false
    private var selectedIndexPath: IndexPath? = nil
    private var inSearchMode = false
    weak var delegate: SearchVCDelegate?
    var isUp = false
    var interstitial: GADInterstitial!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        listButton.isHidden = true
        listButton.addTarget(self, action: #selector(listButtonTapped(_:)), for: .touchUpInside)
        tableView.register(UINib(nibName: "PropertyCell", bundle: nil),
                           forCellReuseIdentifier: "PropertyCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
    
    func viewDidSwipeDown() {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
    }
    
    @objc func listButtonTapped(_ sender: UIButton) {
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
        if isUp { searchBar.searchTextField.resignFirstResponder() }
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CITIES"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProperties {
            if inSearchMode {
                return searchProperties.count
            } else {
                return filteredProperties.count
            }
        } else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
        if isProperties {
            let property: Property
            if inSearchMode {
                property = searchProperties[indexPath.row]
            } else {
                property = filteredProperties[indexPath.row]
            }
            cell.configure(property)
        } else {
            let city = cities[indexPath.row]
            cell.configure(city.city,
                           selectedIndexPath: &selectedIndexPath,
                           indexPath: indexPath,
                           numberOfProperties: "\(city.count) Properties")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isProperties {
            tableView.deselectRow(at: indexPath, animated: true)
            let property = filteredProperties[indexPath.row]
            let detailVC = DetailVC(property: property)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 80))
        headerView.backgroundColor = UIColor.darkmodeColor()
        headerView.addSubview(listButton)
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.contentHorizontalAlignment = .trailing
        NSLayoutConstraint.activate([
            listButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            listButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            listButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
        ])
        return headerView
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.didBeginEditing(searchBar: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            inSearchMode = false
        } else {
            var _searchProperties = [Property]()
            _searchProperties = filteredProperties.filter {
                ($0.propertyzip?.contains(searchText.lowercased().trimmingCharacters(in: .whitespaces)) ?? false)
            }
            _searchProperties += filteredProperties.filter {
                ($0.propertyaddress?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            searchProperties = _searchProperties
            inSearchMode = true
        }
        tableView.reloadData()
    }
}

extension UIColor {
    static func darkmodeColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? .black : .white
            }
        }
        else { return .white }
    }
}

