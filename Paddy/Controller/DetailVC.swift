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
        setupTableView()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ShadowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShadowCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return tableData.count
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return tableData[section].title
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShadowCell", for: indexPath) as? ShadowCell else {
            return UITableViewCell()
        }
        let property = tableData[indexPath.row]
        cell.titleLabel.text = property.title
        cell.detailLabel.text = property.detail
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
//        let detail = tableData[indexPath.section].detail
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = detail
        return cell
    }
}
