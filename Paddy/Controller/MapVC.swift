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
        centerMapOnLocation()
        dropPins()
    }
    
    @objc func mapListViewButtonTapped(_ sender: UIButton) {
        transitionViews()
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
        let mapListButton = UIBarButtonItem(customView: mapListViewButton)
        let locationButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItems = [locationButton, mapListButton]
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
    
    private func dropPins() {
        for property in properties {
            if let annotation = PropertyPointAnnotation(property: property) {
                mapView.addAnnotation(annotation)
            }
        }
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
            let locationCoordinate = property.locationCoordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: locationCoordinate,
                                                  latitudinalMeters: 5000,
                                                  longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let coordinate = view.annotation?.coordinate else { return }
//        let region = MKCoordinateRegion(center: coordinate,
//                                        latitudinalMeters: 1000,
//                                        longitudinalMeters: 1000)
//        mapView.setRegion(region, animated: true)
//        mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
        
        
        
        
//                guard let bikeAnnotation = view.annotation as? BikePointAnnotation,
//            let bike = bikeAnnotation.bike,
//            let popUpVC = mapPopUpVC,
//            let latitude = bikeAnnotation.bike?.latitude,
//            let longitude = bikeAnnotation.bike?.longitude else {
//                return
//        }
//        popUpVC.configBike(bike: bike)
//        popUpVC.configFavorite(isFavorite: bike.isFavorite)
//        UIView.animate(withDuration: 0.25, animations: {
//            self.mapPopUpHeight.constant = 238
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        let coordinate = CLLocationCoordinate2DMake(latitude - 0.0028, longitude)
//        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
//        mapView.setRegion(region, animated: true)
//        mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
    }
}


