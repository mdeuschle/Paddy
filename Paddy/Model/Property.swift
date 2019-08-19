//
//  Property.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

struct Property {
    let propertyJSON: PropertyJSON?
    private(set) var address = ""
    private(set) var city = ""
    private(set) var state = ""
    private(set) var zip = ""
    
    init(propertyJSON: PropertyJSON) {
        self.propertyJSON = propertyJSON
        if let data = propertyJSON.property_location?.human_address?.data(using: .utf8) {
            do {
                if let addressDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    address = addressDictionary["address"] ?? ""
                    city = addressDictionary["city"] ?? ""
                    state = addressDictionary["state"] ?? ""
                    zip = addressDictionary["zip"] ?? ""
                }
            } catch {
                print("ERR: \(error)")
            }
        }
    }
}



