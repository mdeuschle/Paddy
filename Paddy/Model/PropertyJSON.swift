//
//  Property.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

struct PropertyJSON: Decodable {
    let apn: String?
    let registereddate: String?
    let property_type: String?
    let property_location: PropertyLocation?
    
    struct PropertyLocation: Decodable {
        let latitude: String?
        let longitude: String?
        let human_address: String?
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
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    
}


//apn: "2560025012",
//registereddate: "2014-07-09T00:00:00.000",
//property_type: "Single Family",
//property_location: {
//    latitude: "34.25454125300007",
//    longitude: "-118.31404309999999",
//    human_address: "{"address": "10205 N SCOVILLE AVE", "city": "Los Angeles", "state": "CA", "zip": "91040"}"
//},
//zip_code: "91040",
//cd: "7",
//lender: "Wells Fargo Bank N.A.",
//lendercontact: "Amy Whitcomb",
//lendercontactphone: "877-617-5274",
//propertymanagement: "Lender Processing Services",
//propertymgmtcontact: "Amy Whitcomb",
//propmgmt_address: "1003 E Brier DR San Bernardino CA 92408",
//propertycontactphone: "877-617-8274",
//:@computed_region_qz3q_ghft: "3221",
//:@computed_region_k96s_3jcv: "15",
//:@computed_region_tatf_ua23: "1511",
//:@computed_region_kqwf_mjcx: "1",
//:@computed_region_2dna_qi2s: "7"
//},
