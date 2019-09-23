//
//  Property.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation
import CoreLocation

struct Property: Decodable {
    
    let apn: String?
    let registered_date: String?
    let property_type: String?
    let propertyaddress: String?
    let propertycity: String?
    let propertystate: String?
    let propertyzip: String?
    let councildistrict: String?
    let lender: String?
    let lendercontact: String?
    let lendercontactphone: String?
    let lon: String?
    let lat: String?
    
    var locationCoordinate: CLLocationCoordinate2D? {
        guard let latitude = lat,
            let longitude = lon,
            let lat = Double(latitude),
            let lon = Double(longitude) else { return nil }
        return CLLocationCoordinate2DMake(lat, lon)
    }
}



