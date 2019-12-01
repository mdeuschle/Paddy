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
            centerMapOnLocation()
            dropPins()
            searchVC?.properties = properties
        }
    }
    private var cities = [(city: String, count: Int)]()
    let locationManager = CLLocationManager()
    private var searchVC: SearchVC?
    private var selectedCity = "LOS ANGELES" {
        didSet {
            title = selectedCity
            centerMapOnLocation()
        }
    }
    private var alertView: AlertView!
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
        raiseSearchVC()
    }
    
    @objc private func swipeDown() {
        dismissSearchVC()
        searchVC?.viewDidSwipeDown()
    }
    
    private func raiseSearchVC() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.searchVCHeight.constant = (self?.view.bounds.height ?? 60) / 1.28
            self?.view.layoutIfNeeded()
        }
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
                let _cities = properties.compactMap { $0.propertycity }
                let mappedCities = _cities.compactMap { ($0, 1) }
                let cityDictionary = Dictionary(mappedCities, uniquingKeysWith: +)
                var tuples = [(String, Int)]()
                for (key, value) in cityDictionary { tuples.append((key, value)) }
                let cities = tuples.sorted { $0.0 < $1.0 }.filter { !$0.0.contains("APN")}
                self?.cities = cities
                self?.searchVC?.cities = cities
            case let .failure(error):
                self?.alertView?.show(error: error.localizedDescription)
            }
        }
    }
    
    private func setupUI() {
        title = selectedCity
        definesPresentationContext = true
        let locationButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = locationButton
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
        }, completion: nil)
    }
    
    private func dropPins() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        let filteredProperties = properties.filter { $0.propertycity == selectedCity }
        for property in filteredProperties {
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
        let selectedProperties = properties.filter { $0.propertycity == selectedCity }
        let property = selectedProperties[(selectedProperties.count - 1) / 2]
        if let locationCoordinate = property.locationCoordinate {
            let coordinateRegion = MKCoordinateRegion(center: locationCoordinate,
                                                      latitudinalMeters: 5000,
                                                      longitudinalMeters: 5000)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PropertyPointAnnotation else { return nil }
        let identifier = "annotation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PropertyPointAnnotation else { return }
        let detailVC = DetailVC(property: annotation.property)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MapVC: SearchVCDelegate {
    
    func didSelect(list: UIButton) {
        
    }
    
    func didSelect(city: String) {
        selectedCity = city
        dropPins()
    }
    
    func didBeginEditing(searchBar: UISearchBar) {
        raiseSearchVC()
    }
    
    func didTap(button: UIButton) {
        guard let searchVC = searchVC else { return }
        if searchVC.isUp {
            dismissSearchVC()
        } else {
            raiseSearchVC()
        }
    }
}


