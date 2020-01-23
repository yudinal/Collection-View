//
//  DetailViewController.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    var country: CountryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    func updateUI() {
        guard let chosenCountry = country else {
            fatalError(" country is nil, verify prepare(for segue: )")
        }
        nameLabel.text = chosenCountry.name
        capitalLabel.text = ("Capital: \(chosenCountry.capital)")
        populationLabel.text = ("Population: \(chosenCountry.population.description) people")
        
        let imageURL = "https://www.countryflags.io/\(chosenCountry.alpha2Code)/flat/64.png"
        
        
            FlagImageClient.fetchImage(for: imageURL) { [unowned self] (result) in
                switch result {
                case .failure(let error):
                    print("error \(error)")
                case .success(let image):
                    DispatchQueue.main.async {
                        self.flagImage.image = image
                    }
                }
            }
        }
    }



