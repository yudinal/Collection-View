//
//  FlagImageClient.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import UIKit

struct FlagImageClient {

    static func fetchImage(for urlString: String,
                           completion: @escaping (Result<UIImage?, Error>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            print("bad url \(urlString)")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
         
            if let error = error {
                print("eror \(error)")
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                
                completion(.success(image))
            }
        }
        dataTask.resume()
    }
}
