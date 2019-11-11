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

final class MapVC: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchVCHeight: NSLayoutConstraint!
    
    let spinner = UIActivityIndicatorView(style: .gray)
    let propertyStore = PropertyStore()
    var properties = [Property]() {
        didSet {
            print(properties)
            centerMapOnLocation()
            dropPins()
            searchVC?.properties = properties
        }
    }
    var cities = [String]()
    let locationManager = CLLocationManager()
    private var searchVC: SearchVC?
    private var selectedCity = "LOS ANGELES" {
        didSet {
            title = selectedCity
        }
    }
    private var alertView: AlertView!
    
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
        setupSpinner()
        configureLocationServices()
        setupUI()
        downloadProperties()
        tableView.dataSource = self
        setupSearchVC()
        setupSwipeGestureRecognizers()
    }
    
    private func setupSearchVC() {
        if let searchVC = children.last as? SearchVC { self.searchVC = searchVC }
        searchVC?.delegate = self
        searchVCHeight.constant = 0
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.searchVCHeight.constant = (self?.view.bounds.height ?? 60) / 3.5
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupSwipeGestureRecognizers() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUpGesture.direction = .up
        searchVC?.view.addGestureRecognizer(swipeUpGesture)
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDownGesture.direction = .down
        searchVC?.view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc private func swipeUp() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.searchVCHeight.constant = (self?.view.bounds.height ?? 60) / 1.18
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func swipeDown() {
        dismissSearchVC()
    }
    
    private func dismissSearchVC() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.searchVCHeight.constant = (self?.view.bounds.height ?? 60) / 3.5
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupSpinner() {
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func loadSearchVC() {
        let searchVC = SearchVC(nibName: nil, bundle: nil)
        searchVC.properties = properties
        present(searchVC, animated: true, completion: nil)
    }
    
    @objc private func mapListViewButtonTapped(_ sender: UIButton) {
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
        
    private func downloadProperties() {
        propertyStore.downloadProperties { [weak self] result in
            self?.spinner.stopAnimating()
            switch result {
            case let .success(properties):
                let properties = properties.filter { $0.propertyaddress != nil }
                self?.properties = properties
                self?.searchVC?.properties = properties
                let citiesArray = properties.compactMap { $0.propertycity }
                let cities = Array(Set(citiesArray)).sorted().filter { !$0.contains("APN") }
                self?.cities = cities
                self?.searchVC?.cities = cities
            case let .failure(error):
                self?.alertView?.show(error: error.localizedDescription)
            }
        }
    }
    
    private func setupUI() {
        title = "LOS ANGELES"
        definesPresentationContext = true
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
        cell.detailTextLabel?.text = property.propertyzip
        return cell
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    
}

extension MapVC: MKMapViewDelegate {
    
    private func centerMapOnLocation() {
        let losAngelesProperties = properties.filter { $0.propertycity == "LOS ANGELES" }
        for property in losAngelesProperties {
            if let locationCoordinate = property.locationCoordinate {
                let coordinateRegion = MKCoordinateRegion(center: locationCoordinate,
                                                          latitudinalMeters: 5000,
                                                          longitudinalMeters: 5000)
                mapView.setRegion(coordinateRegion, animated: true)
                break
            }
        }
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
        guard let coordinate = view.annotation?.coordinate else { return }
        let c = CLLocationCoordinate2D(latitude: coordinate.latitude - 0.002,
                                       longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: c,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)

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

extension MapVC: SearchVCDelegate {
    func didSelect(city: String) {
        dismissSearchVC()
    }
}


