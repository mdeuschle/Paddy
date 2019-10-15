//
//  PropertyStore.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

final class PropertyStore {
    func downloadProperties(completion: @escaping ((Result<[Property], Error>)) -> Void) {
        WebService.shared.dataTask { result in
            switch result {
            case let .success(data):
                do {
                    let properties = try JSONDecoder().decode([Property].self, from: data)
                    let sortedProperties = properties.sorted { $0.propertyaddress ?? "" < $1.propertyaddress ?? "" }
                    completion(.success(sortedProperties))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
