//
//  CustomCell.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    
    func configureCell(for country: CountryData) {
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        populationLabel.text = country.population.description
        
        
        FlagImageClient.fetchImage(for: "https://www.countryflags.io/\(country.alpha2Code)/flat/64.png") { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.flagImage.image = image
                }
            case .failure(let error):
                print("error\(error)")
            }
        }
    }

}
