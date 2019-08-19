//
//  PropertyStore.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

struct PropertyStore {
    private init() {}
    static let shared = PropertyStore()
    func downloadProperties(completion: @escaping (Result<[PropertyJSON], Error>) -> Void) {
        WebService.shared.dataTask { result in
            switch result {
            case let .success(data):
                do {
                    let properties = try JSONDecoder().decode([PropertyJSON].self, from: data)
                    completion(.success(properties))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
