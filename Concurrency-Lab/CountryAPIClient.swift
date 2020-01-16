//
//  CountryAPIClient.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import Foundation

struct CountryAPIClient {
    static func getCountry(completion: @escaping (Result<[CountryData], AppError>) -> ()) {
        let endpointURLString = "https://restcountries.eu/rest/v2/"
        
        NetworkHelper.shared.performDataTask(with: endpointURLString) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let searches = try JSONDecoder().decode([CountryData].self, from: data)
                    let countries = searches
                    completion(.success(countries))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
