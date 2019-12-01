//
//  PropertyPointAnnotation.swift
//  Paddy
//
//  Created by Matt Deuschle on 9/22/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation
import MapKit

class PropertyPointAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init?(property: Property) {
        guard let title = property.propertyaddress,
            let coordinate = property.locationCoordinate else { return nil }
        self.title = title
        self.subtitle = property.registered_date?.dateString()
        self.coordinate = coordinate
    }
}
