//
//  CountryData.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import Foundation

struct AppleSearchAPI: Decodable {
    let results: [CountryData]
}
struct CountryData: Decodable {
    let name: String
    let capital: String
    let population: Int
    let flag: String
    let alpha2Code: String
}
