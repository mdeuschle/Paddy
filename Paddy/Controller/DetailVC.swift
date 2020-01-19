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
    private var property: Property!
    
    init(property: Property) {
        tableData = property.all()
        self.property = property
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action,
                                     target: self,
                                     action: #selector(shareContent))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Property Details"
        setupTableView()
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ShadowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShadowCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
    }
    
    @objc private func shareContent() {
        let vc = UIActivityViewController(activityItems: [property.details()],
                                          applicationActivities: [])
        present(vc, animated: true)
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
