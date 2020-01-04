//
//  DetailVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/30/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

final class DetailVC: UITableViewController {
    
    private var tableData = [TableData]()
    
    init(property: Property) {
        var _tableData = [TableData]()
        for detail in property.details() {
            if detail.detail != nil {
                _tableData.append(detail)
            }
        }
        tableData = _tableData
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Property Details"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        let detail = tableData[indexPath.section].detail
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = detail
        return cell
    }
}
