//
//  ListVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/4/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {
    
    var properties = [Property]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListCell.self, forCellReuseIdentifier: "listCell")

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = properties[indexPath.row].propertyaddress
        return cell
    }
}

class ListCell: UITableViewCell {
    
    
}
