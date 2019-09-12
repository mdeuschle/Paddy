//
//  MapVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class MapVC: UIViewController {
    
    var properties = [Property]()
    
    let mapListViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("List", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @objc func mapListViewButtonTapped(_ sender: UIButton) {
        transitionViews()
    }
    
    private func setUpUI() {
        navigationItem.largeTitleDisplayMode = .never
        mapListViewButton.addTarget(self, action: #selector(mapListViewButtonTapped(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: mapListViewButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func transitionViews() {
        mapListViewButton.titleLabel?.text == "List" ? showListView() : showMapView()
    }
    
    private func showListView() {
        let listVC = ListVC(nibName: nil, bundle: nil)
        listVC.properties = properties
        listVC.view.tag = 99
        UIView.transition(with: view,
                          duration: 0.4,
                          options: [.transitionCurlUp, .curveEaseIn],
                          animations: {
                            self.view.addSubview(listVC.view)
                            let guide = self.view.safeAreaLayoutGuide
                            listVC.view.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                listVC.view.topAnchor.constraint(equalTo: guide.topAnchor),
                                listVC.view.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                listVC.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                listVC.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                                ])
                            self.configureButtonTitle()
        }, completion: nil)
    }
    
    private func showMapView() {
        UIView.transition(with: view,
                          duration: 0.4,
                          options: [.transitionCurlDown, .curveEaseIn],
                          animations: {
                            if let listView = self.view.viewWithTag(99) {
                                listView.removeFromSuperview()
                            }
                            self.configureButtonTitle()
        }, completion: nil)
    }
    
    private func configureButtonTitle() {
        let buttonTitle = mapListViewButton.titleLabel?.text == "List" ? "Map" : "List"
        mapListViewButton.setTitle(buttonTitle, for: .normal)
    }
}
