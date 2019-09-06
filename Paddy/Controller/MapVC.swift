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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let listVC = ListVC(nibName: nil, bundle: nil)
        navigationController?.pushViewController(listVC, animated: true)
//        present(listVC, animated: true)
    }
}
