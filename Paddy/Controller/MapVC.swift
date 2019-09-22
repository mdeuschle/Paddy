//
//  MapVC.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/1/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var properties = [Property]()
    let locationManager = CLLocationManager()
    
    let mapListViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("List", for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        return UITableView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        setUpUI()
        tableView.dataSource = self
        configureRightBarButtonItem()
        centerMapOnLocation()
    }
    
    @objc func mapListViewButtonTapped(_ sender: UIButton) {
        transitionViews()
    }
    
    private func configureRightBarButtonItem() {
        let locationButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = locationButton
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
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
        UIView.transition(with: view,
                          duration: 0.4,
                          options: [.transitionCurlUp, .curveEaseIn],
                          animations: {
                            self.view.addSubview(self.tableView)
                            let guide = self.view.safeAreaLayoutGuide
                            self.tableView.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.tableView.topAnchor.constraint(equalTo: guide.topAnchor),
                                self.tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                self.tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                self.tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                                ])
                            self.configureButtonTitle()
        }, completion: nil)
    }
    
    private func showMapView() {
        UIView.transition(with: view,
                          duration: 0.4,
                          options: [.transitionCurlDown, .curveEaseIn],
                          animations: {
                            self.tableView.removeFromSuperview()
                            self.configureButtonTitle()
        }, completion: nil)
    }
    
    private func configureButtonTitle() {
        let buttonTitle = mapListViewButton.titleLabel?.text == "List" ? "Map" : "List"
        mapListViewButton.setTitle(buttonTitle, for: .normal)
    }
}

extension MapVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let property = properties[indexPath.row]
        cell.textLabel?.text = property.propertyaddress
        return cell
    }
}

extension MapVC: CLLocationManagerDelegate {
    

}

extension MapVC: MKMapViewDelegate {
    
    private func centerMapOnLocation() {
        guard let property = properties.first,
            let latitude = property.lat,
            let longitude = property.lon,
        let lat = Double(latitude),
        let lon = Double(longitude) else { return }
        let locationCoordinate = CLLocationCoordinate2DMake(lat, lon)
        let coordinateRegion = MKCoordinateRegion(center: locationCoordinate,
                                                  latitudinalMeters: 5000,
                                                  longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

 
