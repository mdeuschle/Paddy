//
//  PropertyStore.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

class PropertyStore {
    func downloadProperties(completion: @escaping ((Result<[Property], Error>), ([String]?)) -> Void) {
        WebService.shared.dataTask { result in
            switch result {
            case let .success(data):
                do {
                    let properties = try JSONDecoder().decode([Property].self, from: data)
                    let sortedProperties = properties.sorted { $0.propertyaddress ?? "" < $1.propertyaddress ?? "" }
                    let citiesArray = properties.compactMap { $0.propertycity }
                    let cities = Array(Set(citiesArray)).sorted()
                    completion(.success(sortedProperties), cities)
                } catch {
                    completion(.failure(error), nil)
                }
            case let .failure(error):
                completion(.failure(error), nil)
            }
        }
    }
}
