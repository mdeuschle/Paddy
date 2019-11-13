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
    private var selectedIndexPath: IndexPath? = nil
    weak var delegate: SearchVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
    }
    
    func viewDidSwipeDown() {
        guard let indexPath = selectedIndexPath else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
        let button = UIButton(type: .system)
        let buttonFrame = CGRect(x: tableView.frame.width - 65,
                                 y: 12,
                            width: 54,
                            height: 44)
        button.frame = buttonFrame
        button.setTitle("List", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 100))
        headerView.addSubview(button)
        return headerView
    }
}
