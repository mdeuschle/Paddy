//
//  Property.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

struct Property: Decodable {
    let apn: String?
    let registereddate: String?
    let property_type: String?
    let property_location: PropertyLocation?
    
    struct PropertyLocation: Decodable {
        let latitude: String?
        let longitude: String?
        let human_address: HumanAddress
        
        struct HumanAddress: Decodable {
            let address: String?
            let city: String?
            let state: String?
            let zip: String?
        }
    }
    
        let zip_code: String?
        let cd: String?
        let lender: String?
        let lendercontact: String?
        let lendercontactphone: String?
        let propertymanagement: String?
        let propertymgmtcontact: String?
        let propmgmt_address: String?
        let propertycontactphone: String?
}

