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
    let propertymanagement: String?
    let propertymanagementcontact: String?
    let propertymgmtcontactphone: String?
    let propertymanagementaddress: String?
    
    var locationCoordinate: CLLocationCoordinate2D? {
        guard let latitude = lat,
            let longitude = lon,
            let lat = Double(latitude),
            let lon = Double(longitude) else { return nil }
        return CLLocationCoordinate2DMake(lat, lon)
    }
    
    var address: String? {
        let _address = propertyaddress?.capitalized ?? ""
        let _city = propertycity?.capitalized ?? ""
        let _state = propertystate?.uppercased() ?? ""
        let _zip = propertyzip ?? ""
        return _address
            + " "
            + _city
            + " "
            + _state
            + " "
            + _zip
    }
}

typealias TableData = (title: String, detail: String?)

extension Property {
    func details() -> [TableData] {
        return [
            ("Registered Date", registered_date?.dateString()),
            ("Property Type", property_type?.capitalized),
            ("Address", address),
            ("Councel District", councildistrict?.capitalized),
            ("Lender", lender?.capitalized),
            ("Lender Contact", lendercontact?.capitalized),
            ("Lender Contact Phone", lendercontactphone?.capitalized),
            ("Property Management", propertymanagement?.capitalized),
            ("Property Management Contact", propertymanagementcontact?.capitalized),
            ("Property Management Address", propertymanagementaddress),
            ("Property Management Phone", propertymgmtcontactphone?.capitalized),
            ("APN", apn?.capitalized)
        ]
    }
}

extension String {
    func dateString() -> String? {
        let dateString = self.replacingOccurrences(of: ".", with: "+")
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}





