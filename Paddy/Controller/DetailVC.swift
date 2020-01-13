//
//  DetailVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/30/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

final class DetailVC: UITableViewController {
    
    private var tableData = [[TableData]]()
    
    init(property: Property) {
        tableData = property.all()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShadowCell", for: indexPath) as? ShadowCell else {
            return UITableViewCell()
        }
        cell.configure(tableData: tableData, at: indexPath.section)
        return cell
    }
}
