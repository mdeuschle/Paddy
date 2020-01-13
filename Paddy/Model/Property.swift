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
    
    var propManagementAddress: String? {
        guard let address = propertymanagementaddress else { return nil }
        return address.replacingOccurrences(of: "  ", with: " ")
    }
}

typealias TableData = (type: PropertyType, detail: String?)

extension Property {
    private func dateDetails() -> [TableData] {
        return [
            (.registeredDate, registered_date?.dateString()),
        ]
    }
    
    private func attributesDetails() -> [TableData] {
        return [
            (.type, property_type?.capitalized),
            (.address, address),
            (.councelDistrict, councildistrict?.capitalized),
            (.apn, apn?.capitalized),
        ]
    }
    
    private func lenderDetails() -> [TableData] {
        return [
            (.lender, lender?.capitalized),
            (.lenderContact, lendercontact?.capitalized),
            (.lenderContactPhone, lendercontactphone?.capitalized),
        ]
    }
    
    private func managementDetails() -> [TableData] {
        return [
            (.propertyManagement, propertymanagement?.capitalized),
            (.propertyManagementContact, propertymanagementcontact?.capitalized),
            (.propertyManagementAddress, propManagementAddress),
            (.propertyManagementPhone, propertymgmtcontactphone?.capitalized),
        ]
    }
    
    func all() -> [[TableData]] {
        return [dateDetails(), attributesDetails(), lenderDetails(), managementDetails()]
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

enum PropertyType: String {
    case registeredDate = "Registered Date"
    case type = "Property Type"
    case address = "Address"
    case councelDistrict = "Councel District"
    case apn = "Assessor's Parcel Number"
    case lender = "Lender"
    case lenderContact = "Lender Contact"
    case lenderContactPhone = "Lender Contact Phone"
    case propertyManagement = "Property Management"
    case propertyManagementContact = "Property Management Contact"
    case propertyManagementAddress = "Property Management Address"
    case propertyManagementPhone = "Property Management Phone"
}






