//
//  FlagCell.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 1/16/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit

class FlagCell: UICollectionViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    func configureCell(for country: CountryData) {
        nameLabel.text = country.name
        capitalLabel.text = ("Capital: \(country.capital)")
        populationLabel.text = ("Population: \(country.population.description)")
        
        
        FlagImageClient.fetchImage(for: "https://www.countryflags.io/\(country.alpha2Code)/flat/64.png") { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.flagImage.image = image
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.flagImage.image = UIImage(systemName: "exclamationmark-triangle")
                }
            }
        }
    }
}
