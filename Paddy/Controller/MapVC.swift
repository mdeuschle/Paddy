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
        print("TAP: \(sender.title)")
        let listVC = ListVC(nibName: nil, bundle: nil)
        let guide = view.safeAreaLayoutGuide
        view.addSubview(listVC.view)
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: guide.topAnchor),
            listVC.view.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            listVC.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
    
    private func setUpUI() {
        navigationItem.largeTitleDisplayMode = .never
        mapListViewButton.addTarget(self, action: #selector(mapListViewButtonTapped(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: mapListViewButton)
        navigationItem.rightBarButtonItem = barButtonItem

        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {

    }
}
