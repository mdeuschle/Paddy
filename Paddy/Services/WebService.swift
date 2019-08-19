//
//  WebService.swift
//  Paddy
//
//  Created by Matt Deuschle on 8/18/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

struct WebService {
    private init() {}
    static let shared = WebService()
    func dataTask(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://data.lacity.org/resource/fdwe-pgcu.json?$limit=5&$$app_token=LFuu36jqve2Td9BWBffSS1iJm") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if data != nil && error == nil {
                completion(.success(data!))
            } else {
                if data != nil {
                    completion(.failure(error!))
                }
            }
        }
        task.resume()
    }
}
