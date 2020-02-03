//
//  DetailVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 11/30/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

final class DetailVC: UITableViewController {
    
    private var tableData = [[TableData]]()
    private var property: Property!
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-4242338858452610/3741814942"
        bannerView.delegate = self
        bannerView.rootViewController = self
        return bannerView
    }()
    
    init(property: Property) {
        tableData = property.all()
        self.property = property
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Property Details"
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareContent))
        bannerView.load(GADRequest())
        SKStoreReviewController.requestReview()
    }
    
    private func setupBannerAd() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.alpha = 0
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bannerView.heightAnchor.constraint(equalTo: bannerView.heightAnchor),
            bannerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ShadowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShadowCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
    }
    
    @objc private func shareContent() {
        let vc = UIActivityViewController(activityItems: property.getDetails(),
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

extension DetailVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        setupBannerAd()
        UIView.animate(withDuration: 0.4) {
            bannerView.alpha = 1
        }
    }
}

